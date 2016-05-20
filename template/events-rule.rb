#
# Events Rule
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-events-rule.html
#
require 'kumogata/template/helper'
require 'kumogata/template/events'

name = _resource_name(args[:name], "events rule")
description = args[:description] || ""
pattern = _events_pattern(args)
role = _ref_attr_string("role", "Arn", args, "role")
event_name = _ref_name("event", args)
schedule = args[:schedule] || ""
state = _valid_values(args[:state], %w( enabled disabled ), "enabled")
targets = _events_targets(args)

_(name) do
  Type "AWS::Events::Rule"
  Properties do
    Description description unless description.empty?
    EventPattern pattern unless schedule.empty?
    Name event_name
    RoleArn role unless role.empty?
    ScheduleExpression schedule unless schedule.empty?
    State state.upcase
    Targets targets unless targets.empty?
  end
end
