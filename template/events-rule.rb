#
# Events Rule
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-events-rule.html
#
require 'kumogata/template/helper'
require 'kumogata/template/events'

name = _resource_name(args[:name], "events rule")
description = _ref_string_default("description", args, '', "#{args[:name]} events rule description")
pattern = _events_pattern(args)
event = _name("event", args)
schedule = _events_to_schedule_expression(args[:schedule])
state = _valid_values(args[:state], %w( enabled disabled ), "enabled")
targets = _events_targets(args)
depends = _depends([ { ref_lambda_function: 'lambda function' } ], args)

_(name) do
  Type "AWS::Events::Rule"
  Properties do
    Description description unless description.empty?
    EventPattern pattern if schedule.empty?
    Name event
    ScheduleExpression schedule if pattern.empty?
    State state.upcase
    Targets targets unless targets.empty?
  end
  DependsOn depends unless depends.empty?
end
