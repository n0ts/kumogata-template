#
# Output dynanmodb
#
require 'kumogata/template/helper'

_output "#{args[:name]} table",
        ref_value: "#{args[:name]} table",
        export: _export_string(args, "table")
_output "#{args[:name]} table",
        ref_value: [ "#{args[:name]} table", "StreamArn" ],
        export: _export_string(args, "stream arn") if args.key? :stream
