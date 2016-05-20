#
# RDS DBInstance resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-rds-database-instance.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "db instance")
engine = _valid_values(args[:engine],
                       %w( mysql mariadb
                           oracle-se1 oracle-se oracle-ee
                           sqlserver-ee sqlserver-se sqlserver-ex sqlserver-web
                           postgres aurora ), RDS_DEFAULT_ENGINE)
allocated = args[:allocated] || 5
allow = _bool("allow", args, true)
auto = _bool("auto", args, true)
az = _availability_zone(args, false)
backup_retention = args[:backup_retention] || 7
character = args[:character] || ""
cluster = _ref_string("cluster", args, "db cluster")
instance_class = _ref_string("instance_class", args, "db instance classes")
instance_class = _valid_values(instance_class, RDS_INSTANCE_CLASSES, RDS_DEFAULT_INSTANCE_CLASS) unless instance_class.is_a? Hash
instance_id = _ref_name("instance_id", args, "db instance id")
db_name = _ref_string("db_name", args, "db name")
parameter = _ref_string("parameter", args, "db parameter group")
parameter = "default.mysql5.7" if parameter.empty?
security = _ref_array("security_groups", args, "security group")
subnet_group = _ref_string("subnet_group", args, "db subnet group")
snapshot = _ref_string("snapshot", args, "db snapshot")
engine_version = _ref_string("engine_version", args, "db engine version")
engine_version = RDS_DEFAULT_ENGINE_VERSION[engine.to_sym] if engine_version.empty?
iops = args[:iops] || ""
user_name = _ref_string("user_name", args, "db master user name")
user_password = _ref_string("user_password", args, "db master user password")
multi_az = _bool("multi_az", args, false)
option = _ref_string("option", args, "db option group")
port = _ref_string("port", args, "db port")
port = PORT[args[:engine]] if port.empty?
backup_window = _window_time("rds", args[:backup_start] || DEFAULT_SNAPSHOT_TIME[:rds])
maintenance = _maintenance_window("rds", args[:maintenance] || DEFAULT_MAINTENANCE_TIME[:rds])
publicly = _bool("publicly", args, false)
source_db = _ref_string("source_db", args, "db source db")
storage_encrypted = _bool("encrypted", args, false)
tags = _tags(args)
security_groups = _ref_array("security_groups", args, "security group")

_(name) do
  Type "AWS::RDS::DBInstance"
  Properties do
    AllocatedStorage allocated
    AllowMajorVersionUpgrade allow
    AutoMinorVersionUpgrade auto
    AvailabilityZone az unless multi_az
    BackupRetentionPeriod backup_retention if 0 < backup_retention
    CharacterSetName character if !character.empty? and engine =~ /^oracle.*$/
    DBClusterIdentifier cluster if engine == "aurora" and !cluster.empty?
    DBInstanceClass instance_class
    DBInstanceIdentifier instance_id
    DBName db_name if snapshot.empty?
    DBParameterGroupName parameter unless parameter.empty?
    DBSecurityGroups security if security_groups.empty?
    DBSnapshotIdentifier snapshot unless snapshot.empty?
    DBSubnetGroupName subnet_group
    Engine engine
    EngineVersion engine_version
    Iops iops unless iops.empty?
    #KmsKeyId
    #LicenseModel
    MasterUsername user_name
    MasterUserPassword user_password
    MultiAZ multi_az
    OptionGroupName option unless option.empty?
    Port port
    PreferredBackupWindow backup_window
    PreferredMaintenanceWindow maintenance
    PubliclyAccessible publicly
    SourceDBInstanceIdentifier source_db unless source_db.empty?
    StorageEncrypted storage_encrypted if storage_encrypted == true
    #StorageType
    Tags tags
    VPCSecurityGroups security_groups unless security_groups.empty?
  end
end
