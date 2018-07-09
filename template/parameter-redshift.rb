#
# Redshift parameter
#
require 'kumogata/template/helper'

no_echo = _bool("no_echo", args, true)

_parameter "#{args[:name]} redshift cluster node types",
           default: args[:node_type] || REDSHIFT_DEFAULT_NODE_TYPE,
           description: "#{args[:name]} redshift cluster node types",
           values: REDSHIFT_NODE_TYPES

_parameter "#{args[:name]} redshift cluster port",
           default: args[:port],
           description: "#{args[:name]} redshift cluster port",
           type: "number"

_parameter "#{args[:name]} redshift cluster db name",
           default: args[:db_name],
           description: "#{args[:name]} redshift cluster db name",
           pattren: "lower number" if args.key? :db_name

_parameter "#{args[:name]} redshift cluster master user name",
           default: args[:user_name],
           description: "#{args[:name]} redshift cluster master user name",
           pattren: "letters numbers",
           length: { min: 2, max: 16 }

_parameter "#{args[:name]} redshift cluster master user password",
           default: args[:user_password],
           description: "#{args[:name]} redshift cluster master user password",
           pattren: "letters numbers",
           length: { min: 8, max: 64 },
           no_echo: no_echo

_parameter "#{args[:name]} redshift cluster zone name",
           default: args[:zone],
           description: "#{args[:name]} redshift cluster zone name",
           type: "zone name" if args.key? :zone
