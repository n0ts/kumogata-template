#
# IAM Policy resource
# https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-iam-policy.html
#
require 'kumogata/template/helper'
require 'kumogata/template/iam'

name = _resource_name(args[:name], "policy")
groups = _ref_array("groups", args, "group")
policy = _name("policy", args)
roles = _ref_array("roles", args, "role")
users = _ref_array("users", args, "user")

_(name) do
  Type "AWS::IAM::Policy"
  Properties do
    Groups groups unless groups.empty?
    PolicyDocument do
      Version "2012-10-17"
      Statement _iam_policy_document("policy_document", args)
    end
    PolicyName policy
    Roles roles unless roles.empty?
    Users users unless users.empty?
  end
end
