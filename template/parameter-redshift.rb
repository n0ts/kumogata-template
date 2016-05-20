#
# Redshift parameter
#
require 'kumogata/template/helper'

_parameter "#{args[:name]} redshift cluster node types",
           default: args[:node_type] || REDSHIFT_DEFAULT_NODE_TYPE,
           description: "#{args[:name]} redshift cluster node types",
           allowed_values: REDSHIFT_NODE_TYPES
