#
# Output name
#
require 'kumogata/template/helper'

_output "#{args[:name]} name",
        ref_value: args[:name], export: _export_string(args, args[:name])
