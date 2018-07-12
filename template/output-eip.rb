#
# Output eip
#
require 'kumogata/template/helper'

_output "#{args[:name]} eip",
        ref_value: "#{args[:name]} eip",
        export: _export_string(args, "eip")
_output "#{args[:name]} eip allocation",
        ref_value: [ "#{args[:name]} eip", "AllocationId" ],
        export: _export_string(args, "eip allocation")
