#
# EC2 Network Interface resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-network-interface.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "network interface")
description = _ref_string_default("description", args)
group_set = _ref_array("group_set", args, "security group")
ipv6_addresses = args[:ipv6_addresses] || []
private_ip = args[:private_ip] || ""
private_ips = args[:private_ips] || ""
secondary_private_ip = args[:secondary_private_ip] || ""
source_dest = _bool("source_dest", args, false)
subnet = _ref_string("subnet", args, "subnet")
tags = _tags(args)

_(name) do
  Type "AWS::EC2::NetworkInterface"
  Properties do
    Description description unless description.empty?
    GroupSet group_set unless group_set.empty?
    Ipv6AddressCount ipv6_addresses.size unless ipv6_addresses.empty?
    Ipv6Addresses ipv6_addresses unless ipv6_addresses.empty?
    PrivateIpAddress private_ip unless private_ips.empty?
    PrivateIpAddresses private_ips unless private_ip.empty?
    SecondaryPrivateIpAddressCount secondary_private_ip unless secondary_private_ip.empty?
    SourceDestCheck source_dest
    SubnetId subnet
    Tags tags
  end
end
