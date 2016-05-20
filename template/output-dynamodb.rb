#
# Output dynanmodb
#

_output "#{args[:name]} table", ref_value: "#{args[:name]} table"
_output "#{args[:name]} table", ref_value: [ "#{args[:name]} table", "StreamArn" ] if args.key? :stream
