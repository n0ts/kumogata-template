#
# Output rds
#
require 'kumogata/template/helper'

_output "#{args[:name]} db instance",
        ref_value: "#{args[:name]} db instance",
        export: _export_string(args, "#{args[:name]} db instance")
_output "#{args[:name]} db instance address",
        ref_value: [ "#{args[:name]} db instance", "Endpoint.Address" ],
        export: _export_string(args, "#{args[:name]} db instance endpoint address")
_output "#{args[:name]} db instance port",
        ref_value: [ "#{args[:name]} db instance", "Endpoint.Port" ],
        export: _export_string(args, "#{args[:name]} db instance endpoint port")
