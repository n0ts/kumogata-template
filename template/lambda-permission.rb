#
# Lambda permission resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-lambda-permission.html
#
require 'kumogata/template/helper'
require 'kumogata/template/iam'

name = _resource_name(args[:name], "lambda permission")
action = args[:action] || 'invoke function'
function = _ref_attr_string("function", "Arn", args, "lambda function", 'arn')
principal = args[:principal]
source_account = _ref_string("source_account", args, "account id")
source_account = _ref_pseudo('account id') if source_account.empty? and principal == 's3'
source_arn_prefix =
  case principal
  when 's3'
    'bucket'
  when 'sns'
    'topic'
  when 'events'
    'events rule'
    # TBD
  else
    ''
  end
source_arn =
  case principal
  when 'sns'
    _ref_string("source_arn", args, source_arn)
  else
    _ref_attr_string('source_arn', 'Arn', args, source_arn_prefix)
  end

source_arn = _iam_arn("s3", { ref: args[:ref_iam_source_arn] }) if args.key? :ref_iam_source_arn and principal =~ /s3/ and source_arn.empty?
depends = _depends([ { ref_function: 'lambda function' } ], args)

_(name) do
  Type "AWS::Lambda::Permission"
  Properties do
    Action "lambda:#{_capitalize(action)}"
    FunctionName function
    Principal "#{principal}.#{DOMAIN}"
    SourceAccount source_account unless source_account.empty?
    SourceArn source_arn unless source_arn.empty?
  end
  DependsOn depends unless depends.empty?
end
