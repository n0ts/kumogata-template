#
# IAM User resource
# https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-iam-user.html
#
require 'kumogata/template/helper'
require 'kumogata/template/iam'

name = _resource_name(args[:name], "user")
group = _ref_array("group", args)
login_profile =
  if args.key? :login_profile
    _iam_login_profile(args[:login_profile])
  else
    []
  end
managed_policies =
  if args.key? :managed_policies
    _iam_managed_policies(args)
  else
    []
  end
path = args[:path] || "/"
policies = _iam_policies("policies", args)

_(name) do
  Type "AWS::IAM::User"
  Properties do
    Group group unless group.empty?
    LoginProfile login_profile unless login_profile.empty?
    ManagedPolicyArns managed_policies unless managed_policies.empty?
    Path path
    Policies policies unless policies.empty?
  end
end
