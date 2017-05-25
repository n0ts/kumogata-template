#
# Output emr
#
require 'kumogata/template/helper'

_output "#{args[:name]} emr cluster",
        ref_value: "#{args[:name]} emr cluster",
        export: _export_string(args, "erm cluster")
_output "#{args[:name]} emr cluster master public dns",
        ref_value: [ "#{args[:name]} emr cluster", "MasterPublicDNS" ],
        export: _export_string(args, "erm cluster master public dns")
