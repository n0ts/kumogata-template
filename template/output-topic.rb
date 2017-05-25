#
# Output name and topic
#
require 'kumogata/template/helper'

_output "#{args[:name]} topic",
        ref_value: "#{args[:name]} topic",
        export: _export_string(args, "topic")
_output "#{args[:name]} topic name",
        ref_value: [ "#{args[:name]} topic", "TopicName" ],
        export: _export_string(args, "topic name")
