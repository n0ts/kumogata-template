#
# Output ec2 subnet
#
require 'kumogata/template/helper'

_output "#{args[:name]} name", ref_value: args[:name],
                               export: _export_string(args, "subnet name")
_output "#{args[:name]} cidr", ref_value: [ args[:name], "AvailabilityZone" ],
                               export: _export_string(args, "subnet az")
_output "#{args[:name]} subnet ipv6 cidr blocks",
        ref_value: [ vpc, "Ipv6CidrBlocks" ],
        export: _export_string(args, "subnet ipv6 cidr bocks") if args.key? :ipv6
