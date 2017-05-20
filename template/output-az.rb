#
# Output AZ
#
require 'kumogata/template/helper'

_output "#{args[:name]} name", ref_value: args[:name],
                               export: _export_string(args, "#{args[:name]} subnet name")
_output "#{args[:name]} cidr", ref_value: [ args[:name], "AvailabilityZone" ],
                               export: _export_string(args, "#{args[:name]} subnet az")
