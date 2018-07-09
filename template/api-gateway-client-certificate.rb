#
# Api Gateway Client Certificate
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-apigateway-clientcertificate.html
#
require 'kumogata/template/helper'
require 'kumogata/template/api-gateway'

name = _resource_name(args[:name], "client certificate")
description = _ref_string_default("description", args, '', "#{args[:name]} client certificate description")

_(name) do
  Type "AWS::ApiGateway::ClientCertificate"
  Properties do
    Description description
  end
end
