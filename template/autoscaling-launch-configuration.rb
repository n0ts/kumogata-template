#
# Autoscaling LaunchConfiguration
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-as-launchconfig.html
#
require 'kumogata/template/helper'
require 'kumogata/template/ec2'

args[:block_device] = [] unless args.key? :block_device
args[:block_device] += _ec2_to_block_device_ecs(args) if args.key? :ecs

name = _resource_name(args[:name], "autoscaling launch configuration")
public_ip = _bool("public_ip", args, false)
block_device = (args[:block_device] || []).collect{|v| _ec2_block_device(v) }
iam_instance = _ref_string("iam_instance", args, "iam instance profile")
image = _ec2_image(args)
instance = args[:instance] || ""
instance_monitoring = _bool("instance_monitoring", args, true)
instance_type = _ref_string("instance_type", args, "instance type")
kernel = args[:kernel] || ""
key_name = _ref_string("key_name", args, "key name")
placement = _ref_string("placement", args)
ram = args[:ram] || ""
security_groups = _ref_array("security_groups", args, "security group")
spot = args[:spot] || ""
user_data = _ec2_user_data(args)

_(name) do
  Type "AWS::AutoScaling::LaunchConfiguration"
  Properties do
    AssociatePublicIpAddress public_ip
    BlockDeviceMappings block_device unless block_device.empty?
    #ClassicLinkVPCId
    #ClassicLinkVPCSecurityGroups
    #EbsOptimized
    IamInstanceProfile iam_instance unless iam_instance.empty?
    ImageId image
    InstanceId instance unless instance.empty?
    InstanceMonitoring instance_monitoring
    InstanceType instance_type
    KernelId kernel unless kernel.empty?
    KeyName key_name
    PlacementTenancy placement unless placement.empty?
    RamDiskId ram unless ram.empty?
    SecurityGroups security_groups unless security_groups.empty?
    SpotPrice spot unless spot.empty?
    UserData user_data unless user_data.empty?
  end
end
