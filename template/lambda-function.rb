#
# Lambda function resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-lambda-function.html
#
require 'kumogata/template/helper'
require 'kumogata/template/lambda'

name = _resource_name(args[:name], "lambda function")
code = _lambda_function_code(args)
dead_letter = _lambda_dead_letter(args)
description = _ref_string_default("description", args, '', "#{args[:name]} lambda function description")
environment = _lambda_function_environment(args)
function = _name("function", args)
runtime = _lambda_to_runtime(args[:runtime])
handler_index = args[:handler] || 'lambda'
handler =
  case runtime
  when /^nodejs/
    "#{handler_index}.handler"
  when /^python/
    "#{handlerindex}.lambda_handler"
  else
    'lambda.handler'
  end
memory_size = args[:memory_size] || 128
role = _ref_attr_string("role", "Arn", args, "role")
role = _ref_string("role_arn", args, "role") if role.empty?
timeout = args[:timeout] || 300
trace = _lambda_trace_config(args)
vpc_config = _lambda_vpc_config(args)
tags = _tags(args, "function")
depends = _depends([ { ref_role: 'role' } ], args)

_(name) do
  Type "AWS::Lambda::Function"
  Properties do
    Code code
    DeadLetterConfig dead_letter unless dead_letter.empty?
    Description description unless description.empty?
    Environment environment unless environment.empty?
    FunctionName function
    Handler handler
    #KmsKeyArn
    MemorySize memory_size
    Role role
    Runtime runtime
    Timeout timeout
    TracingConfig trace unless trace.empty?
    VpcConfig vpc_config unless vpc_config.empty?
    Tags tags
  end
  DependsOn depends unless depends.empty?
end
