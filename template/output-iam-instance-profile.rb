#
# Output IAM instance profile
#

_output "#{args[:name]} instance profile", ref_value: "#{args[:name]} instance profile"
_output "#{args[:name]} instance profile arn", ref_value: [ "#{args[:name]} instance profile", "Arn" ]
