#
# Helper - Lambda
#
require 'kumogata/template/helper'

def _lambda_function_code(args)
  return "" unless args.key? :code

  code = args[:code]
  s3_bucket = code[:s3_bucket]
  s3_key = code[:s3_key]
  s3_object_version = code[:s3_object_version] || ""

  _{
    S3Bucket s3_bucket
    S3Key s3_key
    S3ObjectVersion s3_object_version unless s3_object_version.empty?
    #ZipFile
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
