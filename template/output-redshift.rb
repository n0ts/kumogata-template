#
# Output redshift
#

_output "#{args[:name]} redshift cluster",
        ref_value: "#{args[:name]} redshift cluster"
_output "#{args[:name]} redshift cluster address",
        ref_value: [ "#{args[:name]} redshift cluster", "Endpoint.Address" ]
_output "#{args[:name]} redshift cluster port",
        ref_value: [ "#{args[:name]} redshift cluster", "Endpoint.Port" ]
