#
# Output IAM role
#

_output "#{args[:name]} role", ref_value: "#{args[:name]} role"
_output "#{args[:name]} role arn", ref_value: [ "#{args[:name]} role", "Arn" ]
