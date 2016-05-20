#
# Helper - EC2
#
require 'kumogata/template/helper'

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

def _ec2_security_group_egresses(name, args)
  return [] unless args.key? name.to_sym

  rules = []
  _array(args[name.to_sym]).each do |arg|
    rules << _ec2_security_group_egress(arg)
  end
  rules
end

def _ec2_security_group_egress(args)
  cidr = args[:cidr] || "0.0.0.0/0"
  destination = _ref_string("destination", args, "security group")
  from = _ref_string("from", args)
  group = _ref_string("group", args, "security group")
  ip = args[:ip_protocol] || "tcp"
  to = _ref_string("to", args)
  from = to if from.empty?

  _{
    CidrIp cidr if destination.empty?
    DestinationSecurityGroupId destination unless destination.empty?
    FromPort from unless ip == "icmp"
    GroupId group unless group.empty?
    IpProtocol ip
    ToPort to unless ip == "icmp"
  }
end

def _ec2_security_group_ingresses(name, args)
  return [] unless args.key? name.to_sym

  rules = []
  _array(args[name.to_sym]).each do |arg|
    rules << _ec2_security_group_ingress(arg)
  end
  rules
end

def _ec2_security_group_ingress(args)
  cidr = args[:cidr] || "0.0.0.0/0"
  from = _ref_string("from", args)
  group_id = _ref_string("group", args, "security group")
  group_name = args[:group_name] || ""
  ip = args[:ip_protocol] || "tcp"
  source_group_name = _ref_string("source_group_name", args, "security group")
  source_group_id = _ref_string("source_group_id", args, "security group")
  source_group_owner_id = _ref_string("source_group_owner_id", args, "account id")
  to = _ref_string("to", args)
  to = from if to.empty?

  _{
    CidrIp cidr if source_group_name.empty? and source_group_id.empty?
    FromPort from unless ip == "icmp"
    GroupId group_id unless group_id.empty?
    GroupName group_name unless group_name.empty?
    IpProtocol ip
    SourceSecurityGroupName source_group_name unless source_group_name.empty?
    SourceSecurityGroupId source_group_id unless source_group_id.empty?
    SourceSecurityGroupOwnerId source_group_name unless source_group_owner_id.empty?
    ToPort to unless ip == "icmp"
  }
end

def _ec2_block_device(args)
  device = args[:device] || "/dev/sda1"
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

def _ec2_network_interface(args)
  associate_public = _bool("associate_public", args, true)
  delete = _bool("delete", args, true)
  description = args[:description] || ""
  device = args[:device] || 0
  group_set = _ref_array("group_set", args, "security group")
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
    GroupSet group_set unless group_set.empty?
    NetworkInterfaceId network_interface unless network_interface.empty?
    PrivateIpAddress private_ip unless private_ip.empty?
    PrivateIpAddresses private_ips unless private_ips.empty?
    SecondaryPrivateIpAddressCount secondary_private_ip unless secondary_private_ip.empty?
    SubnetId subnet
  }
end

def _ec2_image(instance_type, args)
  return args[:image_id] if args.key? :image_id
  resource_image = _resource_name(args[:image] || EC2_DEFAULT_IMAGE)
  _find_in_map("AWSRegionArch2AMI#{resource_image}",
               _{ Ref "AWS::Region" },
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
