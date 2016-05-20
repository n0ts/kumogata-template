#
# Lambda permission resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-lambda-permission.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "lambda permission")
action = args[:action] || "lambda:*"
function_name = _ref_attr_string("function_name", "Arn", args, "lambda function")
principal = _valid_values(args[:principal],
                          %w( s3.amazonaws.com sns.amazonaws.com ),
                          "sns.amazonaws.com")
source_account = _ref_string("source_account", args, "account id")
source_prefix = (principal == "s3.amazonaws") ? "bucket" : "topic"
source_arn = _ref_string("source_arn", args, source_prefix)

_(name) do
  Type "AWS::Lambda::Permission"
  Properties do
    Action action
    FunctionName function_name
    Principal principal
    SourceAccount source_account unless source_account.empty?
    SourceArn source_arn unless source_arn.empty?
  end
end
