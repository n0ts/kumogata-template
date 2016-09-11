#
# Helper - Lambda
#
require 'kumogata/template/helper'

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
    ZipFile _{ Fn__Join '\n', zip_file_code } unless is_s3
  }
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
