#
# Elasticache parameter
#
require 'kumogata/template/helper'

_parameter "#{args[:name]} cache node types",
           default: args[:cache_node] || ELASTICACHE_DEFAULT_NODE_TYPE,
           description: "#{args[:name]} cache node types",
           allowed_values: ELASTICACHE_NODE_TYPES
