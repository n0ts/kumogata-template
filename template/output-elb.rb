#
# Output elb
#

_output "#{args[:name]} load balancer",
        ref_value: "#{args[:name]} load balancer"
_output "#{args[:name]} load balancer canonical hosted zone name",
        ref_value: [ "#{args[:name]} load balancer", "CanonicalHostedZoneName" ] if args.key? :route53
_output "#{args[:name]} load balancer canonical hosted zone id",
        ref_value: [ "#{args[:name]} load balancer", "CanonicalHostedZoneID" ] if args.key? :route53
_output "#{args[:name]} load balancer dns name",
        ref_value: [ "#{args[:name]} load balancer", "DNSName" ]
_output "#{args[:name]} load balancer security group name",
        ref_value: [ "#{args[:name]} load balancer", "SourceSecurityGroup.GroupName" ]
_output "#{args[:name]} load balancer security group owner",
        ref_value: [ "#{args[:name]} load balancer", "SourceSecurityGroup.OwnerAlias" ]
