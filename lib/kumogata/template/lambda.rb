#
# Helper - Lambda
#
require 'kumogata/template/helper'

def _lambda_to_runtime(value)
  case value
  when 'node4'
    'nodejs4.3'
  when 'node6'
    'nodejs6.10'
  when 'node8'
    'nodejs8.10'
  when 'python2'
    'python2.7'
  when 'python3'
    'python3.6'
  when '.net1'
    'dotnetcore1.0'
  when '.net2'
    'dotnetcore2.0'
  when 'go'
    'go1.x'
  else
    value
  end
end

def _lambda_function_code(args)
  return "" unless args.key? :code

  code = args[:code]
  is_s3 = (code.key? :zip_file) ? false : true
  s3_bucket = code[:s3_bucket] || ""
  s3_key = code[:s3_key] || ""
  s3_object_version = code[:s3_object_version] || ""
  zip_file = code[:zip_file] || ""
  unless zip_file.empty?
    zip_file_code = []
    File.foreach(zip_file) do |file|
      file.each_line.collect{|line| zip_file_code << line.chomp }
    end
  end

  _{
    S3Bucket s3_bucket if is_s3
    S3Key s3_key if is_s3
    S3ObjectVersion s3_object_version if is_s3 and !s3_object_version.empty?
    ZipFile _join(zip_file_code, "\n") unless is_s3
  }
end

def _lambda_function_environment(args)
  environment = args[:environment] || {}
  return {} if environment.empty?

  _{ Variables environment }
end

def _lambda_vpc_config(args)
  return "" unless args.key? :vpc

  vpc = args[:vpc]
  security_group_ids = _ref_array("security_groups", vpc, "security group")
  subnet_ids = _ref_array("subnets", vpc, "subnet")
  return {} if security_group_ids.empty? and subnet_ids.empty?

  _{
    SecurityGroupIds security_group_ids unless security_group_ids.empty?
    SubnetIds subnet_ids unless subnet_ids.empty?
  }
end

def _lambda_dead_letter(args)
  return "" unless args.key? :dead_latter

  dead_letter = _ref_string("dead_letter", args)
  _{
    TargetArn dead_letter
  }
end

def _lambda_trace_config(args)
  trace = args[:trace] || ""
  return trace if trace.empty?

  mode =
    case trace
    when "active"
      "Active"
    else
      "PassThrough"
    end
  _{
    Mode mode
  }
end
