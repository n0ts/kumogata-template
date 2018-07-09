#
# Output rds cluster
#
require 'kumogata/template/helper'

_output "#{args[:name]} db cluster",
        ref_value: "#{args[:name]} db cluster",
        export: _export_string(args, "db cluster")
_output "#{args[:name]} db cluster address",
        ref_value: [ "#{args[:name]} db cluster", "Endpoint.Address" ],
        export: _export_string(args, "db cluster endpoint address")
_output "#{args[:name]} db cluster port",
        ref_value: [ "#{args[:name]} db cluster", "Endpoint.Port" ],
        export: _export_string(args, "db cluster endpoint port")
_output "#{args[:name]} db read cluster address",
        ref_value: [ "#{args[:name]} db cluster", "ReadEndpoint.Address" ],
        export: _export_string(args, "db cluster read endpoint address")
