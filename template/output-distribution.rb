#
# Output distribution
#
require 'kumogata/template/helper'

_output "#{args[:name]} distribution",
        ref_value: "#{args[:name]} distribution",
        export: _export_string(args, "distribution")
_output "#{args[:name]} distribution domain",
        ref_value: [ "#{args[:name]} distribution", "DomainName" ],
        export: _export_string(args, "distribution domain")
