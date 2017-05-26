#
# Output dynanmodb
#
require 'kumogata/template/helper'

_output "#{args[:name]} table",
        ref_value: "#{args[:name]} table",
        export: _export_string(args, "#{args[:name]} table")
_output "#{args[:name]} table",
        ref_value: [ "#{args[:name]} table", "StreamArn" ],
        export: _export_string(args, "#{args[:name]} stream arn") if args.key? :stream
