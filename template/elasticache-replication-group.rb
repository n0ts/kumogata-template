#
# Elasticache ReplicationGroupresource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-elasticache-replicationgroup.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "cache replication group")
engine = _valid_values(args[:engine], %w( memcached redis ), ELASTICACHE_DEFAULT_ENGINE)
automatic = _bool("automatic", args, true)
auto = _bool("auto", args, true)
node = _ref_string("node", args, "cache node types")
node = _valid_values(node, ELASTICACHE_NODE_TYPES, ELASTICACHE_DEFAULT_NODE_TYPE) unless node.is_a? Hash
parameter = _ref_string("parameter", args, "cache parameter group")
if parameter.empty?
  if engine == "memcached"
    parameter = "default.memcached1.4"
  else
    parameter = "default.redis2.8"
  end
end
subnet = _ref_string("subnet", args, "cache subnet group")
engine_version = _ref_string("engine_version", args, "cache engine version")
engine_version = ELASTICACHE_DEFAULT_ENGINE_VERSION[engine.to_sym] if engine_version.empty?
notification = _ref_attr_string("notification", "Arn", args)
notification = _ref_string("notification_arn", args) if notification.empty?
num = args[:num] || 2
port = _ref_string("port", args)
port = PORT[engine.to_sym] if port.empty?
azs = _availability_zones(args, false)
maintenance = _maintenance_window("elasticache", args[:maintenance] || DEFAULT_MAINTENANCE_TIME[:elasticache])
description = args[:description] || "#{args[:name]} cache replication group description"
security_groups = _ref_array("security_groups", args, "security group")
snapshot_retention = args[:snapshot_retention] || DEFAULT_SNAPSHOT_NUM
snapshot_window = _window_time("elasticache", args[:snapshot_window_start] || DEFAULT_SNAPSHOT_TIME[:elasticache])

_(name) do
  Type "AWS::ElastiCache::ReplicationGroup"
  Properties do
    AutomaticFailoverEnabled automatic
    AutoMinorVersionUpgrade auto
    CacheNodeType node
    CacheParameterGroupName parameter
    #CacheSecurityGroupNames
    CacheSubnetGroupName subnet
    Engine engine
    EngineVersion engine_version
    NotificationTopicArn notification unless notification.empty?
    NumCacheClusters num
    Port port
    PreferredCacheClusterAZs azs unless azs.empty?
    PreferredMaintenanceWindow maintenance
    ReplicationGroupDescription description
    SecurityGroupIds security_groups unless security_groups.empty?
    #SnapshotArns
    SnapshotRetentionLimit snapshot_retention if 0 < snapshot_retention
    SnapshotWindow snapshot_window unless snapshot_retention < 0 and snapshot_window.empty?
  end
end
