#
# EC2 FlowLog resource
# https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-flowlog.html
#
require 'kumogata/template/helper'
require 'kumogata/template/ec2'

name = _resource_name(args[:name], "flow log")
deliver = _ref_attr_string("deliver", "Arn", args, "role")
log = args[:log] || args[:name]
resource_type_value = _valid_values(args[:type], %w( vpc subnet nic ), "vpc")
resource_id =
  case resource_type_value.downcase
  when "vpc"
    _ref_string("id", args, "vpc")
  when "subnet"
    _ref_string("id", args, "subnet")
  when "nic"
    _ref_string("id", args, "network interface")
  end
resource_type =
  case resource_type_value.downcase
  when "vpc"
    "VPC"
  when "subnet"
    "Subnet"
  when "nic"
    "NetworkInterface"
  end
traffic = _valid_values(args[:traffic], %w( accept reject all ), "all")

_(name) do
  Type "AWS::EC2::FlowLog"
  Properties do
    DeliverLogsPermissionArn deliver unless deliver.empty?
    LogGroupName log
    ResourceId resource_id
    ResourceType resource_type
    TrafficType traffic.upcase
  end
end
