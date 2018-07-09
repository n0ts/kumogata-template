#
# Parameter resource
# https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/parameters-section-structure.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name])
default = args[:default]
default = default.join(", ") if default.is_a? Array
type =
  case args[:type] || ""
  when "num", "number", "integer"
    "Number"
  when "list number", "list num"
    "List<Number>"
  when "list"
    "CommaDelimitedList"
  when "zone name"
    "AWS::EC2::AvailabilityZone::Name"
  when "image id"
    "AWS::EC2::Image::Id"
  when "instance id"
    "AWS::EC2::Instance::Id"
  when "key name"
    "AWS::EC2::KeyPair::KeyName"
  when "security group name"
    "AWS::EC2::SecurityGroup::GroupName"
  when "security group id"
    "AWS::EC2::SecurityGroup::Id"
  when "subnet id"
    "AWS::EC2::Subnet::Id"
  when "volume id"
    "AWS::EC2::Volume::Id"
  when "vpc id"
    "AWS::EC2::VPC::Id"
  when "hosted zone id"
    "AWS::Route53::HostedZone::Id"
  when "zone names"
    "List<AWS::EC2::AvailabilityZone::Name>"
  when "image ids"
    "List<AWS::EC2::Image::Id>"
  when "instance ids"
    "List<AWS::EC2::Instance::Id>"
  when "security group names"
    "List<AWS::EC2::SecurityGroup::GroupName>"
  when "security group ids"
    "List<AWS::EC2::SecurityGroup::Id>"
  when "subnet ids"
    "List<AWS::EC2::Subnet::Id>"
  when "volume ids"
    "List<AWS::EC2::Volume::Id>"
  when "vpc ids"
    "List<AWS::EC2::VPC::Id>"
  when "hosted zone ids"
    "List<AWS::Route53::HostedZone::Id>"
  else
    (default.is_a? Integer) ? "Number" : "String"
  end
description = _ref_string_default("description", args, '', "#{args[:name]} parameter description")
const_description = args[:const_description] || ""
values = args[:values] || []
pattern =
  case args[:pattern] || ""
  when "lower"
    "([a-z])+"
  when "lower number"
    "([a-z]|[0-9])+"
  when "upper"
    "([A-Z])+"
  when "upper number"
    "([A-Z]|[0-9])+"
  when "number"
    "([0-9])+"
  when "letters numbers"
    "([A-Z]|[a-z]|[0-9])+"
  when "ip"
    "(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})/(\\d{1,2})"
  when "version"
    "([0-9]|.)+"
  else
    args[:pattern] || ""
  end
length = args[:length] || {}
value = args[:value] || {}
no_echo = _bool("no_echo", args, nil)
no_echo = true if no_echo.nil? and name =~ /Password/

_(name) do
  Type type
  Default default
  Description description
  ConstraintDescription const_description unless const_description.empty?
  AllowedValues values unless values.empty?
  AllowedPattern pattern unless pattern.empty?
  MaxLength length[:max] unless length.empty?
  MinLength length[:min] unless length.empty?
  MaxValue value[:max] unless value.empty?
  MinValue value[:min] unless value.empty?
  NoEcho no_echo if [true, false].include? no_echo
end
