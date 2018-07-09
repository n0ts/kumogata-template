#
# Output trail
#
require 'kumogata/template/helper'

_output "#{args[:name]} trail",
        ref_value: "#{args[:name]} trail",
        export: _export_string(args, "trail")
_output "#{args[:name]} trail arn",
        ref_value: [ "#{args[:name]} trail", "Arn" ],
        export: _export_string(args, "trail arn")
_output "#{args[:name]} trail sns topic arn",
        ref_value: [ "#{args[:name]} trail", "SnsTopicArn" ],
        export: _export_string(args, "trail sns topic arn") if args.key? :sns_topic
