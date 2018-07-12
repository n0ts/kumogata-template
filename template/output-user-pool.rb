#
# Output user pool
#
require 'kumogata/template/helper'

_output "#{args[:name]} user pool",
        ref_value: "#{args[:name]} user pool",
        export: _export_string(args, "user pool")
_output "#{args[:name]} user pool provider name",
        ref_value: [ "#{args[:name]} user pool", "ProviderName" ],
        export: _export_string(args, "user pool provider name")
_output "#{args[:name]} user pool provider url",
        ref_value: [ "#{args[:name]} user pool", "ProviderURL" ],
        export: _export_string(args, "user pool provider url")
_output "#{args[:name]} user pool arn",
        ref_value: [ "#{args[:name]} user pool", "Arn" ],
        export: _export_string(args, "user pool provider arn")
