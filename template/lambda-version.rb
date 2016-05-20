#
# Lambda version resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-lambda-version.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "lambda version")
code_sha256 = args[:code_sha256] || ""
description = args[:description] || ""
function_name = _ref_attr_string("function_name", "Arn", args, "lambda function")

_(name) do
  Type "AWS::Lambda::Version"
  Properties do
    CodeSha256 code_sha256 unless code_sha256.empty?
    Description description unless description.empty?
    FunctionName function_name
  end
end
