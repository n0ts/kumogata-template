#
# Api Gateway Rest API resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-apigateway-restapi.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "rest api")
binary_types = args[:binary_types] || [] # ex) image/png or application/octet-stream
body = args[:body] || {}
body_s3 = args[:body_s3] || {}
clone = _ref_string_default("clone", args)
description = _ref_string_default("description", args, '', "#{args[:name]} rest api description")
fail_on = _bool("fail_on", args, true)
api = _name("api", args)
parameters = _ref_array("parameters", args)

_(name) do
  Type "AWS::ApiGateway::RestApi"
  Properties do
    BinaryMediaTypes binary_types unless binary_types.empty?
    Body body unless body.empty?
    BodyS3Location body_s3 unless body_s3.empty?
    CloneFrom clone unless clone.empty?
    Description description unless description.empty?
    FailOnWarnings fail_on
    Name api
    Parameters parameters unless parameters.empty?
  end
end
