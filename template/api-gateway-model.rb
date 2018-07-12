#
# Api Gateway Model
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-apigateway-model.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "model")
content = _ref_string_default("content", args, "", "application/json")
description = _ref_string_default("description", args, '', "#{args[:name]} model description")
model = _name("model", args)
rest = _ref_string("rest", args, "rest api")
schema = args[:schema]

_(name) do
  Type "AWS::ApiGateway::Model"
  Properties do
    ContentType content
    Description description unless description.empty?
    Name model
    RestApiId rest
    Schema schema
  end
end
