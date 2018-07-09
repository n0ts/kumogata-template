#
# IAM Group resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-iam-group.html
#
require 'kumogata/template/helper'
require 'kumogata/template/iam'

name = _resource_name(args[:name], "group")
group = _name("group", args)
managed_policies =
  if args.key? :managed_policies
    _iam_managed_policies(args)
  else
    []
  end
path = args[:path] || "/"
policies = _iam_policies("policies", args)

_(name) do
  Type "AWS::IAM::Group"
  Properties do
    GroupName group
    ManagedPolicyArns managed_policies unless managed_policies.empty?
    Path path
    Policies policies unless policies.empty?
  end
end
