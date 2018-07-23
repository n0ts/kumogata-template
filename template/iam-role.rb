#
# IAM role resource
# https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-iam-role.html
#
require 'kumogata/template/helper'
require 'kumogata/template/iam'
require 'kumogata/template/kinesis'
require 'kumogata/template/pinpoint'

args[:managed_policies].collect!{|v| "service-role/#{v}" } if args.key? :managed_policies
args[:policies].each_with_index do |v, i|
  next unless v.key? :type
  case v[:type]
  when /^kinesis firehose/
    args[:policies][i][:document] = _kinesis_firehose_to_delivery_stream_role(v[:document])
  when /^pinpoint kinesis stream/
    args[:policies][i][:document] = _pinpoint_to_kinesis_stream_role(v[:document])
  when /^pinpoint kinesis firehose/
    args[:policies][i][:document] = _pinpoint_to_kinesis_firehose_delivery_stream_role(v[:document])
  end
end if args.key? :policies

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
role = _name("role", args)

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
    RoleName role
  end
end
