#
# RDS DBInstance resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-rds-database-instance.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "db instance")
allocated = _ref_string_default("allocated", args, "", 5)
allow = _bool("allow", args, true)
auto = _bool("auto", args, true)
az = _availability_zone(args, false)
backup_retention = _ref_string_default("backup_retention", args, "", 7)
character = _ref_string_default("character", args)
copy_tags =
  if args.key? :copy_tags
    _bool("copy_tags", args, true)
  else
    ""
  end
cluster = _ref_string_default("cluster", args, "db cluster")
instance_class = _ref_string_default("instance_class", args, "db instance classes", RDS_DEFAULT_INSTANCE_CLASS)
instance_class = _valid_values(instance_class, RDS_INSTANCE_CLASSES, RDS_DEFAULT_INSTANCE_CLASS) if instance_class.is_a? String
instance_id = _name('instance_id', args, '-', 'db instance id')
db_name = _ref_string("db_name", args, "db name")
db_name = _ref_string("database", args, "database") if db_name.empty?
parameter = _ref_string("parameter", args, "db parameter group")
db_security_groups = _ref_array("db_security_groups", args, "db security group")
snapshot = _ref_string("snapshot", args, "db snapshot")
subnet_group = _ref_string("subnet_group", args, "db subnet group")
domain = _ref_string("domain", args, "db domain")
domain_iam = _ref_string("domain_iam", args, "db domain iam")
# Engine http://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBInstance.html
engine = _valid_values(args[:engine],
                       %w( aurora aurora-mysql aurora-postgresql mariadb mysql
                           oracle-ee oracle-se2 oracle-se1 oracle-se postgres
                           sqlserver-ee sqlserver-se sqlserver-ex sqlserver-web ), RDS_DEFAULT_ENGINE)
engine_version = _ref_string_default("engine_version", args, "db engine version", RDS_DEFAULT_ENGINE_VERSION[engine.to_sym])
iops = _ref_string_default("iops", args, "db iops", '')
kms = _ref_attr_string("kms", "Arn", args)
license = _valid_values(args[:license], %w( license-included bring-your-own-license general-public-license ), '')
user_name = _ref_string("user_name", args, "db master user name")
user_password = _ref_string("user_password", args, "db master user password")
monitoring_interval = _ref_string_default("monitoring_interval", args, "db monitoring interval", 0)
monitoring_role_arn = _ref_string("monitoring_role_arn", args, "db monitoring role arn")
multi_az = _bool("multi_az", args, false)
option = _ref_string("option", args, "db option group")
port = _ref_string_default("port", args, "db port", PORT[engine.to_sym])
backup_window = _window_time("rds", args[:backup_start] || DEFAULT_SNAPSHOT_TIME[:rds])
maintenance = _maintenance_window("rds", args[:maintenance] || DEFAULT_MAINTENANCE_TIME[:rds])
publicly = _bool("publicly", args, false)
source_db = _ref_string("source_db", args, "db instance id")
encrypted = _bool("encrypted", args, false)
storage_type = _valid_values(args[:storage_type], %w( standard gp2 io1 ), "gp2")
tags = _tags(args)
timezone = _ref_string_default("timezone", args, "db timezone")
security_groups = _ref_array("security_groups", args, "security group")
deletion_policy = _valid_values(args[:deletion_policy], %w( Delete Retain Snapshot ), "Retain")
depends = _depends([ { ref_master_instance: 'db instance' } ], args)

allocated = "" unless cluster.empty?
if engine =~ /aurora/
  character = ""
  multi_az = ""
end
if parameter.empty?
  parameter =
    if engine == "mysql" and engine_version =~ /5.7/
      "default.mysql5.7"
    elsif engine == "aurora" and engine_version =~ /5.6/
      "default.aurora5.6"
    elsif engine == "postgres" and engine_version =~ /9.4/
      "default.postgres9.4"
    elsif engine == "mariadb" and engine_version =~ /10.0/
      "default.mariadb10.0"
    else
      nil
    end
end
instance_id = instance_id.downcase if instance_id.is_a? String
if engine !~ /sqlserver/
  domain = ""
  domain_iam = ""
end
db_name = "" unless snapshot.empty?
iops = "" if storage_type != "io1"
multi_az = "" unless az.empty?
source_db = "" if engine !~ /(mysql|mariadb|postgres)/
unless source_db.empty?
  snapshot = ""
  backup_retention = ""
  db_name = ""
  subnet_group = ""
  user_name = ""
  user_password = ""
  backup_window = ""
end
encrypted = true unless kms.empty?
if encrypted
  cluster = ""
  snapshot = ""
  source_db = ""
end
security_groups = "" unless db_security_groups.empty?
unless cluster.empty?
  allocated = ""
  backup_retention = ""
  character = ""
  db_security_groups = []
  db_name = ""
  subnet_group = ""
  user_name = ""
  user_password = ""
  option = ""
  backup_window = ""
  maintenance = ""
  port = ""
  source_db = ""
  security_groups = []
  backup_window = ""
  maintenance = ""
  storage_type = ""
end

_(name) do
  Type "AWS::RDS::DBInstance"
  Properties do
    AllocatedStorage allocated unless allocated.empty?
    AllowMajorVersionUpgrade allow
    AutoMinorVersionUpgrade auto
    AvailabilityZone az unless az.empty?
    BackupRetentionPeriod backup_retention unless backup_retention.empty?
    CharacterSetName character unless character.empty?
    CopyTagsToSnapshot copy_tags unless copy_tags.empty?
    DBClusterIdentifier cluster unless cluster.empty?
    DBInstanceClass instance_class
    DBInstanceIdentifier instance_id unless instance_id.empty?
    DBName db_name unless db_name.empty?
    DBParameterGroupName parameter unless parameter.empty?
    DBSecurityGroups db_security_groups unless db_security_groups.empty?
    DBSnapshotIdentifier snapshot unless snapshot.empty?
    DBSubnetGroupName subnet_group unless subnet_group.empty?
    Domain domain unless domain.empty?
    DomainIAMRoleName domain_iam unless domain_iam.empty?
    Engine engine
    EngineVersion engine_version
    Iops iops unless iops.empty?
    KmsKeyId kms unless kms.empty?
    LicenseModel license unless license.empty?
    MasterUsername user_name unless user_name.empty?
    MasterUserPassword user_password unless user_password.empty?
    MonitoringInterval monitoring_interval
    MonitoringRoleArn monitoring_role_arn unless monitoring_role_arn.empty?
    MultiAZ multi_az unless multi_az == ''
    OptionGroupName option unless option.empty?
    Port port unless port.empty?
    PreferredBackupWindow backup_window unless backup_window.empty?
    PreferredMaintenanceWindow maintenance unless maintenance.empty?
    PubliclyAccessible publicly
    SourceDBInstanceIdentifier source_db unless source_db.empty?
    StorageEncrypted encrypted unless kms.empty?
    StorageType storage_type unless storage_type.empty?
    Tags tags
    Timezone timezone unless timezone.empty?
    VPCSecurityGroups security_groups unless security_groups.empty?
  end
  DeletionPolicy deletion_policy unless deletion_policy.empty?
  DependsOn depends unless depends.empty?
end
