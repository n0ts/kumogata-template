#
# Output name and arn
#
require 'kumogata/template/helper'

name =
  if args.key? :resource
    "#{args[:name]} #{args[:resource]}"
  else
    args[:name]
  end

_output "#{name} name", ref_value: name,
                        export: _export_string(args, "name")

_output "#{name} arn", ref_value: [ name, "Arn" ],
                       export: _export_string(args, "arn")
