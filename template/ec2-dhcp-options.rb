#
# EC2 DHCP Options resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-dhcp-options.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "dhcp options")
domain_name = _ref_string("domain_name", args, "domain name")
domain_servers = _ref_array("domain_servers", args, "domain servers")
netbios_servers = _ref_array("netbios_servers", args, "netbios servers")
netbios_type = args[:netbios_type] || 2
ntp_serves = _ref_array("ntp_serves", args, "ntp servers")
tags = _tags(args)

_(name) do
  Type "AWS::EC2::DHCPOptions"
  Properties do
    DomainName domain_name unless domain_name.empty?
    DomainNameServers domain_servers unless domain_servers.empty?
    NetbiosNameServers netbios_servers unless netbios_servers.empty?
    NetbiosNodeType netbios_type unless netbios_servers.empty?
    NtpServers unless ntp_serves.empty?
    Tags tags
  end
end
