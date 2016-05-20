#
# Output ec2
#

_output "#{args[:name]} instance", ref_value: "#{args[:name]} instance"
_output "#{args[:name]} instance az", ref_value: [ "#{args[:name]} instance", "AvailabilityZone" ]
_output "#{args[:name]} instance public ip", ref_value: [ "#{args[:name]} instance", "PublicIp" ] if args.key? :public_ip
_output "#{args[:name]} instance private ip", ref_value: [ "#{args[:name]} instance", "PrivateIp" ]
