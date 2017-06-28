#
# Autoscaling LaunchConfiguration
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-as-launchconfig.html
#
require 'kumogata/template/helper'
require 'kumogata/template/ec2'

name = _resource_name(args[:name], "autoscaling launch configuration")
instance_type = _ref_string("instance_type", args, "instance type")
associate = _bool("associate", args, false)
block_device = (args[:block_device] || []).collect{|v| _ec2_block_device(v) }
iam_instance = _ref_string("iam_instance", args, "iam instance profile")
image = _ec2_image(instance_type, args)
instance = args[:instance] || ""
instance_monitoring = _bool("instance_monitoring", args, true)
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
    AssociatePublicIpAddress associate
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
