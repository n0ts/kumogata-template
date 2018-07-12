#
# Elasticache ReplicationGroupresource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-elasticache-replicationgroup.html
#
require 'kumogata/template/helper'
require 'kumogata/template/elasticache'

name = _resource_name(args[:name], "cache replication group")
engine = _elasticache_to_engine(args)
automatic = _bool("automatic", args, true)
auto = _bool("auto", args, true)
node = _elasticache_to_node(args)
parameter = _elasticache_to_parameter(args)
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
description = _ref_string_default("description", args, '', "#{args[:name]} cache replication group description")
security_groups = _ref_array("security_groups", args, "security group")
snapshot_arn = args[:snapshot_arn] || ""
snapshot_name = args[:snapshot_name] || ""
snapshot_retention = args[:snapshot_retention] || DEFAULT_SNAPSHOT_NUM
snapshot_id = args[:snapshot_id] || ""
snapshot_window = _window_time("elasticache", args[:snapshot_window_start] || DEFAULT_SNAPSHOT_TIME[:elasticache])
tags = _tags(args)

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
    SnapshotArns snapshot_arn unless snapshot_arn.empty?
    SnapshotName snapshot_name unless snapshot_name.empty?
    SnapshotRetentionLimit snapshot_retention if 0 < snapshot_retention
    SnapshottingClusterId snapshot_id unless snapshot_id.empty?
    SnapshotWindow snapshot_window unless snapshot_retention < 0 and snapshot_window.empty?
    Tags tags
  end
end
