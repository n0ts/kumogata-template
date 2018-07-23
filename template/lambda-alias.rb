#
# Lambda alias resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-lambda-alias.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "lambda alias")
description = _ref_string_default("description", args, '', "#{args[:name]} lambda alias description")
function_name = _ref_attr_string("function_name", "Arn", args, "lambda function")
function_version = _ref_attr_string("function_version", "Version", args, "lambda version")
alias_name = _name("alias_name", args)

_(name) do
  Type "AWS::Lambda::Alias"
  Properties do
    Description description unless description.empty?
    FunctionName function_name
    FunctionVersion function_version
    Name alias_name
  end
end
