#
# Output name and arn
#
require 'kumogata/template/helper'

_output "#{args[:name]} name", ref_value: args[:name],
                               export: _export_string(args, "name")
_output "#{args[:name]} arn", ref_value: [ args[:name], "Arn" ],
                              export: _export_string(args, "arn")
