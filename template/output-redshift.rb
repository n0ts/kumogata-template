#
# Output redshift
#
require 'kumogata/template/helper'

_output "#{args[:name]} redshift cluster",
        ref_value: "#{args[:name]} redshift cluster",
        export: _export_string(args, "redshift cluster")
_output "#{args[:name]} redshift cluster address",
        ref_value: [ "#{args[:name]} redshift cluster", "Endpoint.Address" ],
        export: _export_string(args, "redshift cluster endpoint address")
_output "#{args[:name]} redshift cluster port",
        ref_value: [ "#{args[:name]} redshift cluster", "Endpoint.Port" ],
        export: _export_string(args, "redshift cluster endpoint port")
