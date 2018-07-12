#
# Output subnet
#
require 'kumogata/template/helper'

ipv6 = _bool("ipv6", args, false)

_output "#{args[:name]} subnet",
        ref_value: "#{args[:name]} subnet",
        export: _export_string(args, "subnet")
_output "#{args[:name]} subnet az",
        ref_value: [ "#{args[:name]} subnet", "AvailabilityZone" ],
        export: _export_string(args, "subnet az") unless args.key? :no_az
_output "#{args[:name]} subnet ipv6 cidr blocks",
        ref_value: [ "#{args[:name]} subnet", "Ipv6CidrBlocks" ],
        select: 0,
        export: _export_string(args, "subnet ipv6 cidr blocks") if ipv6
