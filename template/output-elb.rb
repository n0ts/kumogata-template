#
# Output elb
#

_output "#{args[:name]} load balancer",
        ref_value: "#{args[:name]} load balancer"
_output "#{args[:name]} load balancer dns name",
        ref_value: [ "#{args[:name]} load balancer", "DNSName" ]
_output "#{args[:name]} load balancer security group name",
        ref_value: [ "#{args[:name]} load balancer", "SourceSecurityGroup.GroupName" ]
_output "#{args[:name]} load balancer securiry group owner",
        ref_value: [ "#{args[:name]} load balancer", "SourceSecurityGroup.OwnerAlias" ]
