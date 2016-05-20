#
# Parameter resource
# https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/parameters-section-structure.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name])
type = args[:type] || "String"
default = args[:default] || ""
allowed_values = args[:allowed_values] || []
description = args[:description] || ""
no_echo = args[:no_echo] || nil

_(name) do
  Type type
  Default default
  AllowedValues allowed_values unless allowed_values.empty?
  Description description
  NoEcho true unless no_echo.nil?
end
