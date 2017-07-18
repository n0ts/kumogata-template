#
# IAM role resource
# https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-iam-role.html
#
require 'kumogata/template/helper'
require 'kumogata/template/iam'

name = _resource_name(args[:name], "role")
policy = _iam_assume_role_policy_document(args)
managed_policies =
  if args.key? :managed_policies
    _iam_managed_policies(args)
  else
    []
  end
path = args[:path] || "/"
policies = _iam_policies("policies", args)
role_name = _real_name("role", args)

_(name) do
  Type "AWS::IAM::Role"
  Properties do
    AssumeRolePolicyDocument do
      Version "2012-10-17"
      Statement policy
    end
    ManagedPolicyArns managed_policies unless managed_policies.empty?
    Path path
    Policies policies unless policies.empty?
    RoleName role_name if role_name
  end
end
