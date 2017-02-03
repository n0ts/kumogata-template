#
# S3 Bucket Policy resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-s3-policy.html
#
require 'kumogata/template/helper'
require 'kumogata/template/iam'

name = _resource_name(args[:name], "bucket policy")
bucket = _ref_string("bucket", args, "bucket")
policy = _iam_policy_document("policy_document", args)

_(name) do
  Type "AWS::S3::BucketPolicy"
  Properties do
    Bucket bucket
    PolicyDocument do
      Version "2012-10-17"
      Statement policy
    end
  end
end
