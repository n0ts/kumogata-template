#
# Output access key
#

_output "#{args[:name]} access key", ref_value: args[:name]
_output "#{args[:name]} secret access key", ref_value: [ args[:name], "SecretAccessKey" ]
