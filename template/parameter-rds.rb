#
# RDS instance parameter
#
require 'kumogata/template/helper'

engine = args[:engine] || RDS_DEFAULT_ENGINE
prefix =
  case engine
  when "aurora"
    "db cluster"
  else
    "db instance"
  end
class_default =
  case engine
  when "aurora"
    RDS_AURORA_DEFAULT_INSTANCE_CLASS
  else
    RDS_DEFAULT_INSTANCE_CLASS
  end
classes =
  case engine
  when "aurora"
    RDS_AURORA_INSTANCE_CLASSES
  else
    RDS_INSTANCE_CLASSES
  end
no_echo = _bool("no_echo", args, true)

_parameter "#{args[:name]} db instance class",
           default: args[:instance_class] || class_default,
           description: "#{args[:name]} #{prefix} db instance class",
           values: classes

_parameter "#{args[:name]} db port",
           default: args[:port],
           description: "#{args[:name]} #{prefix} db port",
           type: "number"

_parameter "#{args[:name]} db name",
           default: args[:db_name],
           description: "#{args[:name]} #{prefix} db name",
           pattren: "lower number" if args.key? :db_name

_parameter "#{args[:name]} db master user name",
           default: args[:user_name],
           description: "#{args[:name]} #{prefix} db master user name",
           pattren: "letters numbers",
           length: { min: 2, max: 16 }

_parameter "#{args[:name]} db master user password",
           default: args[:user_password],
           description: "#{args[:name]} #{prefix} db master user password",
           pattren: "letters numbers",
           length: { min: 8, max: 64 },
           no_echo: no_echo
