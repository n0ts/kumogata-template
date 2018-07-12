#
# Lambda event-source-mapping resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-lambda-eventsourcemapping.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "lambda event source mapping")
batch_size = args[:batch_size] || 100
enabled = _bool("enabled", args, true)
event = _ref_attr_string("event", "Arn", args, args[:event_source_prefix])
function = _ref_attr_string("function", "Arn", args, "lambda function")
starting_position = _valid_values(args[:starting_position],
                                  %w( trim_horizon latest ), "latest")

_(name) do
  Type "AWS::Lambda::EventSourceMapping"
  Properties do
    BatchSize batch_size
    Enabled enabled
    EventSourceArn event
    FunctionName function
    StartingPosition starting_position.upcase
  end
end
