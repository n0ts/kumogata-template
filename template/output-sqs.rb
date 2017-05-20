#
# Output sqs
#
require 'kumogata/template/helper'

_output "#{args[:name]} queue",
        ref_value: "#{args[:name]} queue",
        export: _export_string(args, "#{args[:name]} queue")
