#
# Api Gateway Usage Plan Key resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-apigateway-usageplankey.html
#
require 'kumogata/template/helper'
require 'kumogata/template/api-gateway'

name = _resource_name(args[:name], "usage plan key")
key = _ref_string("key", args)
usage_plan = _ref_string("usage_plan", args, "usage plan")

_(name) do
  Type "AWS::ApiGateway::UsagePlanKey"
  Properties do
    KeyId key
    KeyType "API_KEY"
    UsagePlanId usage_plan
  end
end
