#
# Cognito User Pool Group resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-cognito-userpoolgroup.html
#
require 'kumogata/template/helper'
require 'kumogata/template/cognito'

name = _resource_name(args[:name], "user pool group")
description = _ref_string_default("description", args, '', "#{args[:name]} user pool description")
group = _name("group", args)
precedence = args[:precedence] || ""
role = _ref_string_default("role", args, "role")
pool = _ref_string("pool", args, "user pool")

_(name) do
  Type "AWS::Cognito::UserPoolGroup"
  Properties do
    Description description unless description.empty?
    GroupName group
    Precedence precedence unless precedence.empty?
    RoleArn role unless role.empty?
    UserPoolId pool
  end
end
