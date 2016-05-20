#
# IAM Group resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-iam-group.html
#
require 'kumogata/template/helper'
require 'kumogata/template/iam'

name = _resource_name(args[:name], "group")
manaegd_policy_arns = args[:managed_policy_arns] || []
path = args[:path] || "/"
policies = _iam_policies("policies", args)

_(name) do
  Type "AWS::IAM::Group"
  Properties do
    ManagedPolicyArns manaegd_policy_arns unless manaegd_policy_arns.empty?
    Path path
    Policies policies unless policies.empty?
  end
end
