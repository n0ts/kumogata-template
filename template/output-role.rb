#
# Output role
#
require 'kumogata/template/helper'

_output "#{args[:name]} role",
        ref_value: "#{args[:name]} role",
        export: _export_string(args, "role")
_output "#{args[:name]} role arn",
        ref_value: [ "#{args[:name]} role", "Arn" ],
        export: _export_string(args, "role arn")
