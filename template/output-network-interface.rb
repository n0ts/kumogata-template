#
# Output network interface
#
require 'kumogata/template/helper'

_output "#{args[:name]} network interface",
        ref_value: "#{args[:name]} network interface",
        export: _export_string(args, "network interface")
_output "#{args[:name]} network interface private ip",
        ref_value: [ "#{args[:name]} network interface", "PrimaryPrivateIpAddress" ],
        export: _export_string(args, "network interface private ip")
_output "#{args[:name]} network interface secondary ips",
        ref_value: [ "#{args[:name]} network interface", "SecondaryPrivateIpAddresses" ],
        export: _export_string(args, "network interface secondary ips")
