#
# Helper - EC2
#
require 'kumogata/template/helper'

def _ec2_to_block_device_ecs(args)
  root_device = {
    device: "/dev/xvda",
    delete: _bool("root_delete", args, true),
    size: args[:root_size] || 8,
    type: "gp2",
  }
  root_device[:ref_size] = "#{args[:ref_root_size]} root" if _ref_key? "root_size", args, '', false

  # /dev/xvdcz is Docker's use storage
  data_device = {
     device: "/dev/xvdcz",
     delete: _bool("data_delete", args, true),
     size: args[:data_size],
     type: "gp2",
  }
  data_device[:ref_size] = "#{args[:ref_data_size]} data" if _ref_key? "data_size", args, '', false

  [ root_device, data_device ]
end

def _ec2_tags(args)
  if args.key? :tags_append
    tags_append = {}
    tags_append[:ref_domain] = "domain" unless args[:tags_append].key? :domain
    tags_append[:ref_role] = "role" unless args[:tags_append].key? :role
    tags_append.merge!(args[:tags_append])
    args[:tags_append] = tags_append
  else
    args[:tags_append] = {
      ref_domain: "domain",
      ref_role: "role"
    }
  end
  _tags(args)
end

def _ec2_security_group_egress_rules(name, args)
  return [] unless args.key? name.to_sym

  rules = []
  _array(args[name.to_sym]).each do |arg|
    rules << _ec2_security_group_egress_rule(arg)
  end
  rules
end

def _ec2_security_group_egress_rule(args)
  cidr = args[:cidr] || "0.0.0.0/0"
  cidr_ipv6 = args[:cidr_ipv6] || ""
  dest_security = _ref_string("dest_security", args, "security group")
  description = _ref_string_default("description", args, '', "inbound rule description")
  from = _ref_string("from", args)
  ip = args[:ip] || "tcp"
  dest_prefix = _ref_string("dest_prefix", args, "vpc endpoint")
  to = _ref_string("to", args)
  from = to if from.empty?

  _{
    CidrIp cidr if dest_security.empty?
    CidrIpv6 cidr_ipv6 unless cidr_ipv6.empty?
    DestinationPrefixListId dest_prefix unless dest_prefix.empty?
    Description description
    FromPort from unless ip == "icmp"
    IpProtocol ip
    DestinationSecurityGroupId dest_security unless dest_security.empty?
    ToPort to unless ip == "icmp"
  }
end

def _ec2_security_group_ingress_rules(name, args)
  return [] unless args.key? name.to_sym

  rules = []
  _array(args[name.to_sym]).each do |arg|
    if arg.is_a? Integer
      arg = {
        from: arg,
        to: arg,
      }
    end
    rules << _ec2_security_group_ingress_rule(arg)
  end
  rules
end

def _ec2_security_group_ingress_rule(args)
  cidr = args[:cidr] || "0.0.0.0/0"
  cidr_ipv6 = args[:cidr_ipv6] || ""
  description = _ref_string_default("description", args, '', "inbound rule description")
  from = _ref_string("from", args)
  ip = args[:ip] || "tcp"
  source_group_name = _ref_string("source_group_name", args, "security group")
  source_group_id = _ref_string("source_group_id", args, "security group")
  source_group_owner_id = _ref_string("source_group_owner_id", args, "account id")
  to = _ref_string("to", args)
  to = from.clone if to.empty?
  ip = -1 and from = 0 and to = 65535 if ip == "all"

  _{
    CidrIp cidr if source_group_name.empty? and source_group_id.empty?
    CidrIpv6 cidr_ipv6 unless cidr_ipv6.empty?
    Description description
    FromPort from unless ip == "icmp"
    IpProtocol ip
    SourceSecurityGroupName source_group_name unless source_group_name.empty?
    SourceSecurityGroupId source_group_id unless source_group_id.empty?
    SourceSecurityGroupOwnerId source_group_name unless source_group_owner_id.empty?
    ToPort to unless ip == "icmp"
  }
end

def _ec2_block_device(args)
  device = args[:device] || "/dev/sdb"
  delete = _bool("delete", args, true)
  encrypted = _bool("encrypted", args, false)
  iops = args[:iops] || 300
  snapshot = args[:snapshot] || ""
  size = _ref_string("size", args, "volume size")
  type = _valid_values(args[:type], %w( io1 gp2 sc1 st1 ), "gp2")
  no_device = args[:no_device] || ""
  virtual = args[:virtual] || ""

  _{
    DeviceName device
    Ebs do
      DeleteOnTermination delete
      Encrypted encrypted if encrypted == true
      Iops iops if type == "io1"
      SnapshotId snapshot if device.empty?
      VolumeSize size if snapshot.empty? and !size.empty?
      VolumeType type
    end
    NoDevice no_device unless no_device.empty?
    VirtualName virtual unless virtual.empty?
  }
end

def _ec2_network_interface_embedded(args, is_spot = false)
  associate_public = _bool("associate_public", args, true)
  delete = _bool("delete", args, true)
  description = args[:description] || ""
  device = args[:device] || 0
  group_set = _ref_array("group_set", args, "security group")
  groups = _ref_array("groups", args, "security group")
  network_interface = _ref_string("network", args)
  private_ip = args[:private_ip] || ""
  private_ips = args[:private_ips] || ""
  secondary_private_ip = args[:secondary_private_ip] || ""
  subnet = _ref_string("subnet", args, "subnet")

  _{
    AssociatePublicIpAddress associate_public
    DeleteOnTermination delete
    Description description unless description.empty?
    DeviceIndex device
    if is_spot
      Groups groups unless groups.empty?
    else
      GroupSet group_set unless group_set.empty?
    end
    NetworkInterfaceId network_interface unless network_interface.empty?
    PrivateIpAddress private_ip if is_spot and !private_ip.empty?
    PrivateIpAddresses private_ips unless private_ips.empty?
    SecondaryPrivateIpAddressCount secondary_private_ip unless secondary_private_ip.empty?
    SubnetId subnet
  }
end

def _ec2_image(args)
  return args[:image_id] if args.key? :image_id

  image =
    if args.key? :ecs
      "ecs official"
    else
      args[:image] || EC2_DEFAULT_IMAGE
    end
  instance_type = _ref_string("instance_type", args, "instance type")
  _find_in_map("AWSRegionArch2AMI#{_resource_name(image)}",
               _region,
               _find_in_map("AWSInstanceType2Arch", instance_type, "Arch"))
end

def _ec2_port_range(args)
  _{
    From args[:from] || 0
    To args[:to] || args[:from] || 65535
  }
end

def _ec2_protocol_number(protocol)
  # http://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml
  case protocol
  when 'tcp'
    6
  when 'udp'
    17
  when 'icmp'
    1
  else
    -1
  end
end

def _ec2_user_data(args)
  if args.key? :user_data
    user_data = args[:user_data]
  else
    user_data = _ref_string("user_data", args, "user data")
  end

  if user_data.is_a? Hash
    _base64(user_data)
  else
    if user_data.is_a? String
      if user_data.nil? or user_data.empty?
        user_data = []
      else
        user_data = [ user_data ]
      end
    end
    amazon_linux =
      if args.key? :ecs or args.key? :amazon_linux
        true
      else
        false
      end
    if args.key? :ecs
      # http://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-agent-config.html
      ecs_user_data =<<"EOS"
cat <<'EOF' >> /etc/ecs/ecs.config
ECS_CLUSTER=#{_name("ecs", args)}
EOF
EOS
      user_data = user_data.insert(0, ecs_user_data)
    end
    _base64_shell(user_data)
  end
end

def _ec2_spot_fleet_request(args)
  allocation = _valid_values(args[:allocation], %w( lowestPrice diversified), "lowestPrice")
  express = _valid_values(args[:express], %w( noTermination default), "")
  iam = _ref_attr_string("iam", "Arn", args, "role")
  # TODO move to role.rb
  iam = "aws-ec2-spot-fleet-role" if iam.empty?
  launches = args[:launches].collect{|v| _ec2_spot_fleet_launches(v) }
  price = args[:price] || 0.00
  target = _ref_string("target", args, "")
  target = 1 if target.empty?
  terminate = _bool("terminate", args, false)
  valid_from = (args.key? :valid_from) ? _timestamp_utc(args[:valid_from]) : ''
  valid_until =
    if args.key? :valid_until
      _timestamp_utc(args[:valid_until])
    elsif args.key? :valid_from
      _timestamp_utc(args[:valid_from] + (60 * 60 * 24 * 365))
    else
      ''
    end

  _{
    AllocationStrategy allocation
    ExcessCapacityTerminationPolicy express unless express.empty?
    IamFleetRole iam
    LaunchSpecifications launches
    SpotPrice price
    TargetCapacity target
    TerminateInstancesWithExpiration terminate
    ValidFrom valid_from if args.key? :valid_from
    ValidUntil valid_until if args.key? :valid_from or args.key? :valid_until
  }
end

def _ec2_spot_fleet_launches(args)
  block_devices = (args[:block_devices] || []).collect{|v| _ec2_block_device(v) }
  ebs = _bool("ebs", args, false)
  iam = _ref_string("iam", args, "iam instance profile")
  iam = _ref_attr_string("iam", "Arn", args, "iam instance profile") if iam.empty?
  instance_type = _ref_string("instance_type", args, "instance type")
  image =_ec2_image(instance_type, args)
  kernel = args[:kernel] || ""
  key_name = _ref_string("key_name", args, "key name")
  monitoring = _bool("monitoring", args, false)
  network_interfaces = (args[:network_interfaces] || []).collect{|v| _ec2_network_interface_embedded(v, true) }
  placement = _ref_string("placement", args)
  ram_disk = args[:ram_disk] || ""
  security_groups = _ref_array("security_groups", args, "security group")
  subnet = _ref_string("subnet", args, "subnet")
  user_data = _ec2_user_data(args)
  weighted = args[:weighted] || ""

  _{
    BlockDeviceMappings block_devices unless block_devices.empty?
    EbsOptimized ebs
    IamInstanceProfile do
      Arn iam
    end unless iam.empty?
    ImageId image
    InstanceType instance_type
    KernelId kernel unless kernel.empty?
    KeyName key_name unless key_name.empty?
    Monitoring do
      Enabled monitoring
    end
    NetworkInterfaces network_interfaces unless network_interfaces.empty?
    Placement placement unless placement.empty?
    RamdiskId ram_disk unless ram_disk.empty?
    SecurityGroups security_groups unless security_groups.empty?
    SubnetId subnet unless subnet.empty?
    UserData user_data unless user_data.empty?
    WeightedCapacity weighted if args.key? :weighted
  }
end
