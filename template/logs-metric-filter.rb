#
# Logs metric filter resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-logs-metricfilter.html
#
require 'kumogata/template/helper'
require 'kumogata/template/logs'

name = _resource_name(args[:name], "logs metric filter")
# pattern ex. [timestamps, ip_addresses, error_codes = 1234*, size, ...]
pattern = args[:pattern]
group = _name("group", args)
trans = _logs_metric_filter_transformations(args)

_(name) do
  Type "AWS::Logs::MetricFilter"
  Properties do
    FilterPattern pattern
    LogGroupName group
    MetricTransformations trans
  end
end
