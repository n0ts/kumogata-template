#
# Elasticache parameter
#
require 'kumogata/template/helper'

default = args[:cache_node] || ELASTICACHE_DEFAULT_NODE_TYPE
default = "cache.#{default}" if default !~ /cache./

_parameter "#{args[:name]} cache node types",
           default: default,
           description: "#{args[:name]} cache node types",
           values: ELASTICACHE_NODE_TYPES
