#
# EC2 parameter
#
require 'kumogata/template/helper'

_parameter "#{args[:name]} instance type",
           default: args[:instance] || EC2_DEFAULT_INSTANCE_TYPE,
           description: "#{args[:name]} instance type",
           allowed_values: EC2_INSTANCE_TYPES

_parameter "#{args[:name]} iam instance profile",
           default: args[:iam_instance],
           description: "#{args[:name]} iam instance profile" if args.key? :iam_instance

_parameter "#{args[:name]} data volume size",
           default: args[:size] || 100,
           description: "#{args[:name]} data volume size"

_parameter "#{args[:name]} key name",
           default: args[:key_name],
           description: "#{args[:name]} key name",
           type: "AWS::EC2::KeyPair::KeyName" if args.key? :key_name
