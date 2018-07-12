#
# IAM ManagedPolicty
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-iam-managedpolicy.html
#
require 'kumogata/template/helper'
require 'kumogata/template/iam'

name = _resource_name(args[:name], "managed policy")
description = _ref_string_default("description", args, '', "#{args[:name]} managed policy description")
groups = _ref_array("groups", args)
path = args[:path] || "/"
roles = _ref_array("roles", args)
users = _ref_array("users", args)

_(name) do
  Type "AWS::IAM::ManagedPolicy"
  Properties do
    Description description unless description.empty?
    Groups groups unless groups.empty?
    Path path
    PolicyDocument do
      Version "2012-10-17"
      Statement _iam_policy_document("policy_document", args)
    end
    Roles roles unless roles.empty?
    Users users unless users.empty?
  end
end
