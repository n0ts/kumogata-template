#
# Helper - ElastiCache
#
require 'kumogata/template/helper'

def _elasticache_to_engine(args)
  _valid_values(args[:engine], %w( memcached redis ), ELASTICACHE_DEFAULT_ENGINE)
end

def _elasticache_to_node(args)
  node = _ref_string("node", args, "cache node types")
  if node.is_a? String
    node = "cache.#{node}" if node !~ /cache./
    node = _valid_values(node, ELASTICACHE_NODE_TYPES, ELASTICACHE_DEFAULT_NODE_TYPE) 
  end
  node
end

def _elasticache_to_parameter(args)
  engine = _elasticache_to_engine(args)
  parameter = _ref_string("parameter", args, "cache parameter group")
  if parameter.empty?
    if engine == "memcached"
      parameter = "default.memcached1.4"
    else
      parameter = "default.redis2.8"
    end
  end
  parameter
end
