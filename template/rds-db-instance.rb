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
copy_tags =
  if args.key? :copy_tags
    _bool("copy_tags", args, true)
  else
    ""
  end
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
domain = args[:domain] || ""
domain_iam = args[:domain_iam] || ""
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
storage_type = _valid_values(args[:storage_type], %w( standard gp2 io1 ), "gp2")
tags = _tags(args)
timezone = args[:timezone] || ""
security_groups = _ref_array("security_groups", args, "security group")

_(name) do
  Type "AWS::RDS::DBInstance"
  Properties do
    AllocatedStorage allocated
    AllowMajorVersionUpgrade allow
    AutoMinorVersionUpgrade auto
    AvailabilityZone az unless multi_az
    BackupRetentionPeriod backup_retention if 0 < backup_retention and source_db.empty?
    CharacterSetName character if !character.empty? and engine =~ /^oracle.*$/
    CopyTagsToSnapshot copy_tags unless copy_tags.empty?
    DBClusterIdentifier cluster if engine == "aurora" and !cluster.empty?
    DBInstanceClass instance_class
    DBInstanceIdentifier instance_id
    DBName db_name if snapshot.empty? and source_db.empty?
    DBParameterGroupName parameter unless parameter.empty?
    DBSecurityGroups security if security_groups.empty?
    DBSnapshotIdentifier snapshot if !snapshot.empty? and source_db.empty?
    DBSubnetGroupName subnet_group if source_db.empty?
    Domain domain unless domain.empty? and engine !~ /sqlserver/
    DomainIAMRoleName domain_iam unless domain_iam.empty? and engine !~ /sqlserver/
    Engine engine
    EngineVersion engine_version
    Iops iops unless iops.empty?
    #KmsKeyId
    #LicenseModel
    MasterUsername user_name if source_db.empty?
    MasterUserPassword user_password if source_db.empty?
    MultiAZ (source_db.empty? ? multi_az : false)
    OptionGroupName option unless option.empty?
    Port port
    PreferredBackupWindow backup_window if source_db.empty?
    PreferredMaintenanceWindow maintenance
    PubliclyAccessible publicly
    SourceDBInstanceIdentifier source_db unless source_db.empty?
    StorageEncrypted storage_encrypted if storage_encrypted == true
    StorageType storage_type
    Tags tags
    Timezone timezone unless timezone.empty?
    VPCSecurityGroups security_groups unless security_groups.empty?
  end
end
