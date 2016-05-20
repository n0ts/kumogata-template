#
# Output rds
#

_output "#{args[:name]} db instance",
        ref_value: "#{args[:name]} db instance"
_output "#{args[:name]} db instance address",
        ref_value: [ "#{args[:name]} db instance", "Endpoint.Address" ]
_output "#{args[:name]} db instance port",
        ref_value: [ "#{args[:name]} db instance", "Endpoint.Port" ]
