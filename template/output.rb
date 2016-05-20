#
# Output resource
# https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/outputs-section-structure.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name])
value =
  if args.key? :value
    if args[:value].is_a?(Array) and args[:value].length == 2
      _attr_string(args[:value][0], args[:value][1])
    else
      args[:value]
    end
  elsif args.key? :ref_value
    if args[:ref_value].is_a?(Array) and args[:ref_value].length == 2
      _attr_string(args[:ref_value][0], args[:ref_value][1])
    else
      _ref_string("", { ref_: args[:ref_value] })
    end
  else
    name
  end
description = args[:description] || "description of #{name}"

_(name) do
  Description description
  Value value
end
