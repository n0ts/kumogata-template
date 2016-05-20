#
# Output name + arn
#

_output "#{args[:name]} name", ref_value: args[:name]
_output "#{args[:name]} arn", ref_value: [ args[:name], "Arn" ]
