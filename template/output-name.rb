#
# Output name
#
require 'kumogata/template/helper'

prefix = args[:prefix] || "name"

_output "#{args[:name]} #{prefix}",
        ref_value: args[:name], export: _export_string(args, prefix)

_output "#{args[:name]} #{prefix} name",
        ref_value: [ args[:name], "Name" ], export: _export_string(args, "#{prefix}-name")
