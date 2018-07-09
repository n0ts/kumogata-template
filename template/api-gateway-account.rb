#
# Api Gateway Account resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-apigateway-account.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "account")
cloudwatch = _ref_attr_string("cloudwatch", "Arn", args, "role")

_(name) do
  Type "AWS::ApiGateway::Account"
  Properties do
    CloudWatchRoleArn cloudwatch
  end
end
