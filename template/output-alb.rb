#
# Output alb
#

_output "#{args[:name]} load balancer",
        ref_value: "#{args[:name]} load balancer"
_output "#{args[:name]} load balancer dns name",
        ref_value: [ "#{args[:name]} load balancer", "DNSName" ]
_output "#{args[:name]} load balancer canonical hosted zone id",
        ref_value: [ "#{args[:name]} load balancer", "CanonicalHostedZoneID" ] if args.key? :route53
_output "#{args[:name]} load balancer full name",
        ref_value: [ "#{args[:name]} load balancer", "LoadBalancerFullName" ]
_output "#{args[:name]} load balancer name",
        ref_value: [ "#{args[:name]} load balancer", "LoadBalancerName" ]

if args.key? :security_groups
  args[:security_groups].times do |i|
    _output "#{args[:name]} load balancer security group #{i}",
            value: _select(i, _attr_string(args[:name], "SecurityGroups", "load balancer"))
  end
end
