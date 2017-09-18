#
# Output subnet
#
require 'kumogata/template/helper'

_output "#{args[:name]} subnet",
        ref_value: "#{args[:name]} subnet",
        export: _export_string(args, "subnet")
_output "#{args[:name]} subnet az",
        ref_value: [ "#{args[:name]} subnet", "AvailabilityZone" ],
        export: _export_string(args, "subnet az")
_output "#{args[:name]} subnet ipv6 cidr blocks",
        ref_value: [ vpc, "Ipv6CidrBlocks" ],
        export: _export_string(args, "subnet ipv6 cidr bocks") if args.key? :ipv6
