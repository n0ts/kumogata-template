#
# Output AZ
#

_output "#{args[:name]} name", ref_value: args[:name]
_output "#{args[:name]} cidr", ref_value: [ args[:name], "AvailabilityZone" ]
