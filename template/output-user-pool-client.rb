#
# Output user pool client
#
require 'kumogata/template/helper'

_output "#{args[:name]} user pool client",
        ref_value: "#{args[:name]} user pool client",
        export: _export_string(args, "user pool client")
_output "#{args[:name]} user pool client secret",
        ref_value: [ "#{args[:name]} user pool client", "ClientSecret" ],
        export: _export_string(args, "user pool client secret")
_output "#{args[:name]} user pool client name",
        ref_value: [ "#{args[:name]} user pool client", "Name" ],
        export: _export_string(args, "user pool client name")
