#
# Output access key
#
require 'kumogata/template/helper'

_output "#{args[:name]} access key",
        ref_value: "#{args[:name]} access key",
        export: _export_string(args, "access key")
_output "#{args[:name]} secret access key",
        ref_value: [ "#{args[:name]} access key", "SecretAccessKey" ],
        export: _export_string(args, "secret access key")
