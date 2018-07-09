#
# Cognito User Pool User To Group Attachment resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-cognito-userpoolusertogroupattachment.html#w2ab2c19c10d216b9
#
require 'kumogata/template/helper'
require 'kumogata/template/cognito'

name = _resource_name(args[:name], "user pool user to group attachment")
group = _ref_string("group", args, "user pool group")
user_name = _ref_string("user", args, "user pool user")
pool = _ref_string("pool", args, "user pool")

_(name) do
  Type "AWS::Cognito::UserPoolUserToGroupAttachment"
  Properties do
    GroupName group
    Username user_name
    UserPoolId pool
  end
end
