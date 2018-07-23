#
# EMR Instance Group Config
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-emr-instancegroupconfig.html
#
require 'kumogata/template/helper'
require 'kumogata/template/emr'

name = _resource_name(args[:name], "emr instance group config")
autoscaling = _emr_instance_autoscaling(args)
bid = args[:bid] || ""
configurations = args[:configurations] || []
ebs = _emr_ebs(args)
instance_count = args[:instance_count] || 1
instance_role = args[:instance_role] || "TASK"
instance_type = _ref_string("instance_type", args, "instance type")
instance_type = EMR_DEFAULT_INSTANCE_TYPE  if instance_type.empty?
cluster = _ref_string("cluster", args, "emr cluster")
market = _valid_values("market", %w( on_demand, spot), "on_demand")
config = _name("config", args)

_(name) do
  Type "AWS::EMR::InstanceGroupConfig"
  Properties do
    AutoScalingPolicy autoscaling unless autoscaling.empty?
    BidPrice bid unless bid.empty?
    Configurations configurations unless configurations.empty?
    EbsConfiguration ebs  unless ebs.empty?
    InstanceCount instance_count
    InstanceRole instance_role
    InstanceType instance_type
    JobFlowId cluster
    Market market.upcase
    Name config
  end
end
