#
# EC2 parameter
#
require 'kumogata/template/helper'

args[:iam_instance] = "ecsInstanceRole" if args.key? :ecs and !args.key? :iam_instance

_parameter "#{args[:name]} instance type",
           default: args[:instance] || EC2_DEFAULT_INSTANCE_TYPE,
           description: "#{args[:name]} instance type",
           values: EC2_INSTANCE_TYPES

_parameter "#{args[:name]} iam instance profile",
           default: args[:iam_instance],
           description: "#{args[:name]} iam instance profile" if args.key? :iam_instance

_parameter "#{args[:name]} root volume size",
           default: args[:root_size] || 8,
           description: "#{args[:name]} root volume size"

_parameter "#{args[:name]} data volume size",
           default: args[:data_size],
           description: "#{args[:name]} data volume size" if args.key? :data_size

_parameter "#{args[:name]} key name",
           default: args[:key_name],
           description: "#{args[:name]} key name",
           type: "key name" if args.key? :key_name
