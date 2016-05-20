#
# IAM User resource
# https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-iam-user.html
#
require 'kumogata/template/helper'
require 'kumogata/template/iam'

name = _resource_name(args[:name], "user")
group = _ref_array("group", args)
login_profile = args[:login_profile] || ""
manaegd_policy_arns = args[:managed_policy_arns] || []
path = args[:path] || "/"
policies = _iam_policies("policies", args)

_(name) do
  Type "AWS::IAM::User"
  Properties do
    Group group unless group.empty?
    LoginProfile login_profile unless login_profile.empty?
    ManagedPolicyArns manaegd_policy_arns unless manaegd_policy_arns.empty?
    Path path
    Policies policies unless policies.empty?
  end
end
