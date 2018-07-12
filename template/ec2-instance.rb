#
# EC2 Instance resource
# https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-instance.html
#
require 'kumogata/template/helper'
require 'kumogata/template/ec2'

args[:block_device] = [] unless args.key? :block_device
args[:block_device] += _ec2_to_block_device_ecs(args) if args.key? :ecs

name = _resource_name(args[:name], "instance")
instance_type = _ref_string("instance_type", args, "instance type")
affinity = _valid_values(args[:affinity], %w( host default ), "")
az = _availability_zone(args)
block_device = (args[:block_device] || []).collect{|v| _ec2_block_device(v) }
disable_termination = _bool("disable_termination", args, false)
host_id = args[:host_id] || ""
iam_instance = _ref_string("iam_instance", args, "iam instance profile")
image =_ec2_image(instance_type, args)
instance_initiated = args[:instance_initiated] || "stop"
ipv6_addresses = args[:ipv6_addresses] || []
kernel = args[:kernel] || ""
key_name = _ref_string("key_name", args, "key name")
monitoring = _bool("monitoring", args, true)
network_interfaces = (args[:network_interfaces] || []).collect{|v| _ec2_network_interface_embedded(v) }
placement = _ref_string("placement", args)
private_ip = args[:private_ip] || ""
ram_disk = args[:ram_disk] || ""
security_groups = _ref_array("security_groups", args, "security group")
source_dest = _bool("source_dest", args, true)
ssm = args[:ssm] || []
subnet = _ref_string("subnet", args, "subnet")
tags = _ec2_tags(args)
tenancy = args[:tenancy] || "default"
user_data = _ec2_user_data(args)
volumes = args[:volumes] || ""

_(name) do
  Type "AWS::EC2::Instance"
  Properties do
    Affinity affinity unless affinity.empty?
    AvailabilityZone az unless az.empty?
    BlockDeviceMappings block_device
    DisableApiTermination disable_termination
    #EbsOptimized
    HostId host_id unless affinity.empty? and host_id.empty?
    IamInstanceProfile iam_instance unless iam_instance.empty?
    ImageId image
    InstanceInitiatedShutdownBehavior instance_initiated
    InstanceType instance_type
    Ipv6AddressCount ipv6_addresses.size unless ipv6_addresses.empty?
    Ipv6Addresses ipv6_addresses unless ipv6_addresses.empty?
    KernelId kernel unless kernel.empty?
    KeyName key_name
    Monitoring monitoring
    NetworkInterfaces network_interfaces unless network_interfaces.empty?
    PlacementGroupName placement unless placement.empty?
    PrivateIpAddress private_ip unless private_ip.empty?
    RamdiskId ram_disk unless ram_disk.empty?
    #SecurityGroupIds
    SecurityGroups security_groups unless security_groups.empty?
    SourceDestCheck source_dest
    SsmAssociations ssm unless ssm.empty?
    SubnetId subnet unless subnet.empty?
    Tags tags
    Tenancy tenancy unless tenancy.empty?
    UserData user_data unless user_data.empty?
    Volumes volumes unless volumes.empty?
  end
end
