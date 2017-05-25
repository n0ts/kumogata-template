#
# Output autoscaling
#
require 'kumogata/template/helper'

_output "#{args[:name]} autoscaling group",
        ref_value: "#{args[:name]} autoscaling group",
        export: _export_string(args, "autoscaling group")
_output "#{args[:name]} autoscaling launch configuration",
        ref_value: "#{args[:name]} autoscaling launch configuration",
        export: _export_string(args, "autoscaling launch configuration")
