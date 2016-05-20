#
# RDS DBCluster resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-rds-dbcluster.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "db cluster")
az = _availability_zone(args)
backup_retention = args[:backup_retention] || 7
db_name = _ref_name("database", args, "database")
parameter = _ref_string("parameter", args, "db cluster parameter group")
parameter = "default.aurora5.6" if parameter.empty?
subnet_group = _ref_string("subnet_group", args, "db subnet group")
engine = "aurora"
engine_version = RDS_DEFAULT_ENGINE_VERSION[:aurora]
user_name = _ref_string("user_name", args, "db master user name")
user_password = _ref_string("user_password", args, "db master user password")
port = args[:port] || 3306
backup_window = _window_time("rds", args[:backup_start] || DEFAULT_SNAPSHOT_TIME[:rds])
maintenance = _maintenance_window("rds", args[:maintenance] || DEFAULT_MAINTENANCE_TIME[:rds])
snapshot = args[:snapshot] || ""
encrypted = _bool("encrypted", args, false)
tags = _tags(args)
security_groups = _ref_array("security_groups", args, "security group")

_(name) do
  Type "AWS::RDS::DBCluster"
  Properties do
    AvailabilityZone az unless az.empty?
    BackupRetentionPeriod backup_retention if 0 < backup_retention
    DatabaseName db_name
    DBClusterParameterGroupName parameter
    DBSubnetGroupName subnet_group
    Engine engine
    EngineVersion engine_version
    #KmsKeyId
    MasterUsername user_name
    MasterUserPassword user_password
    Port port
    PreferredBackupWindow backup_window
    PreferredMaintenanceWindow maintenance
    SnapshotIdentifier snapshot unless snapshot.empty?
    StorageEncrypted encrypted if encrypted == true
    Tags tags
    VpcSecurityGroupIds security_groups unless security_groups.empty?
  end
end
