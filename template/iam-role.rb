#
# IAM role resource
# https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-iam-role.html
#
require 'kumogata/template/helper'
require 'kumogata/template/iam'

name = _resource_name(args[:name], "role")
policy = _iam_assume_role_policy_document(args)
path = args[:path] || "/"

_(name) do
  Type "AWS::IAM::Role"
  Properties do
    AssumeRolePolicyDocument do
      Version "2012-10-17"
      Statement policy
    end
    Path path
  end
end
