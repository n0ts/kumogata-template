#
# ElastiCache CacheCluster resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-elasticache-cache-cluster.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "cache cluster")
engine = _valid_values(args[:engine], %w( memcached redis ), ELASTICACHE_DEFAULT_ENGINE)
auto = _bool("auto", args, true)
azmode = args[:azmode] || ""
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
cluster = _ref_name("cluster", args, "cache cluster")
engine_version = _ref_string("engine_version", args, "cache engine version")
engine_version = ELASTICACHE_DEFAULT_ENGINE_VERSION[engine.to_sym] if engine_version.empty?
notification = _ref_attr_string("notification", "Arn", args)
notification = _ref_string("notification_arn", args) if notification.empty?
num = args[:num] || 1
port = _ref_string("port", args)
port = PORT[engine.to_sym] if port.empty?
az = _availability_zone(args, false)
azs = _availability_zones(args, false)
maintenance = _maintenance_window("elasticache", args[:maintenance] || DEFAULT_MAINTENANCE_TIME[:elasticache])
snapshot_arn = args[:snapshot_arn] || ""
snapshot_name = args[:snapshot_name] || ""
snapshot_retention = args[:snapshot_retention] || DEFAULT_SNAPSHOT_NUM
snapshot_window = _window_time("elasticache", args[:snapshot_window_start] || DEFAULT_SNAPSHOT_TIME[:elasticache])
tags = _tags(args)
security_groups = _ref_array("security_groups", args, "security group")

_(name) do
  Type "AWS::ElastiCache::CacheCluster"
  Properties do
    AutoMinorVersionUpgrade auto
    AZMode azmode unless azmode.empty? and engine == "redis"
    CacheNodeType node
    CacheParameterGroupName parameter
    #CacheSecurityGroupNames
    CacheSubnetGroupName subnet
    ClusterName cluster
    Engine engine
    EngineVersion engine_version
    NotificationTopicArn notification unless notification.empty?
    NumCacheNodes num
    Port port
    PreferredAvailabilityZone az if engine == "redis" and !az.empty?
    PreferredAvailabilityZones azs if engine == "memached" and !azs.empty?
    PreferredMaintenanceWindow maintenance
    SnapshotArns snapshot_arn unless snapshot_arn.empty?
    SnapshotName snapshot_name unless snapshot_name.empty?
    SnapshotRetentionLimit snapshot_retention if engine == "redis"
    SnapshotWindow snapshot_window if engine == "redis"
    Tags tags
    VpcSecurityGroupIds security_groups unless security_groups.empty?
  end
end
