#
# Output domain name
#
require 'kumogata/template/helper'

_output "#{args[:name]} domain name domain",
        ref_value: "#{args[:name]} domain name",
        export: _export_string(args, "domain name")
_output "#{args[:name]} domain name distribution",
        ref_value: [ "#{args[:name]} domain name", "DistributionDomainName" ],
        export: _export_string(args, "domain name distribution")
