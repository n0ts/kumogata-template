#
# Lambda version resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-lambda-version.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "lambda version")
code_sha256 = args[:code_sha256] || ""
description = args[:description] || ""
function = _ref_attr_string("function", "Arn", args, "lambda function")
depends = _depends([ { ref_function: 'lambda function' } ], args)

_(name) do
  Type "AWS::Lambda::Version"
  Properties do
    CodeSha256 code_sha256 unless code_sha256.empty?
    Description description unless description.empty?
    FunctionName function
  end
  DependsOn depends unless depends.empty?
end
