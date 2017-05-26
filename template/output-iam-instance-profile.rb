#
# Output IAM instance profile
#
require 'kumogata/template/helper'

_output "#{args[:name]} instance profile",
        ref_value: "#{args[:name]} instance profile",
        export: _export_string(args, "#{args[:name]} instance profile")
_output "#{args[:name]} instance profile arn",
        ref_value: [ "#{args[:name]} instance profile", "Arn" ],
        export: _export_string(args, "#{args[:name]} profile arn")
