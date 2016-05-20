#
# Lambda event-source-mapping resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-lambda-eventsourcemapping.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "lambda event source mapping")
batch_size = args[:batch_size] || 100
enabled = _bool("enabled", args, true)
event_source = _ref_attr_string("event_source", "Arn", args, args[:event_source_prefix])
function_name = _ref_attr_string("function_name", "Arn", args, "lambda function")
starting_position = _valid_values(args[:starting_position],
                                  %w( trim_horizon latest ), "latest")

_(name) do
  Type "AWS::Lambda::EventSourceMapping"
  Properties do
    BatchSize batch_size
    Enabled enabled
    EventSourceArn event_source
    FunctionName function_name
    StartingPosition starting_position.upcase
  end
end
