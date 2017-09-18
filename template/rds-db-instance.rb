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
instance_id = _ref_name("instance_id", args, "db instance id")
db_name = _ref_string("db_name", args, "db name")
db_name = _ref_string("database", args, "database") if _empty? db_name
parameter = _ref_string("parameter", args, "db parameter group")
# TODO support AWS::RDS::DBSecurityGroup
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-rds-security-group.html
db_security_groups = _ref_array("db_security_groups", args, "db security group")
snapshot = _ref_string("snapshot", args, "db snapshot")
subnet = _ref_string("subnet", args, "db subnet group")
domain = _ref_string("domain", args, "db domain")
domain_iam = _ref_string("domain_iam", args, "db domain iam")
# http://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBInstance.html
engine = _valid_values(args[:engine],
                       %w( aurora mariadb mysql
                           oracle-ee oracle-se2 oracle-se1 oracle-se postgres
                           sqlserver-ee sqlserver-se sqlserver-ex sqlserver-web ), RDS_DEFAULT_ENGINE)
engine_version = _ref_string_default("engine_version", args, "db engine version", RDS_DEFAULT_ENGINE_VERSION[engine.to_sym])
iops =
  if _ref_key?("iops", args, "db iops")
    _ref_string_default("iops", args, "db iops", 1000)
  else
    ""
  end
kms = _ref_attr_string("kms", "Arn", args)
license = _valid_values(args[:license], %w( license-included bring-your-own-license general-public-license ), "general-public-license")
user_name = _ref_string("user_name", args, "db master user name")
user_password = _ref_string("user_password", args, "db master user password")
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
## TODO use helper
depends = _resource_name(args[:master_instance], "db instance") unless _empty? source_db

allocated = "" unless _empty? cluster
character = "" if engine =~ /aurora/
parameter =
  if _empty? parameter
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
  else
    nil
  end
instance_id = instance_id.downcase if instance_id.is_a? String
if engine !~ /sqlserver/
  domain = ""
  domain_iam = ""
end
db_name = "" unless _empty? snapshot
iops = "" if storage_type != "io1"
multi_az = false unless _empty? az
source_db = "" if engine !~ /(mysql|mariadb|postgres)/
unless _empty? source_db
  multi_az = false
  snapshot = ""
  backup_retention = ""
  db_name = ""
  subnet = ""
  user_name = ""
  user_password = ""
  backup_window = ""
end
encrypted = true unless _empty? kms
if encrypted
  cluster = ""
  snapshot = ""
  source_db = ""
end
security_groups = "" unless _empty? db_security_groups
unless _empty? cluster
  allocated = ""
  backup_retention = ""
  character = ""
  db_security_groups = []
  db_name = ""
  subnet = ""
  user_name = ""
  user_password = ""
  multi_az = ""
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
    AllocatedStorage allocated unless _empty? allocated
    AllowMajorVersionUpgrade allow
    AutoMinorVersionUpgrade auto
    AvailabilityZone az unless _empty? az
    BackupRetentionPeriod backup_retention unless _empty? backup_retention
    CharacterSetName character unless _empty? character
    CopyTagsToSnapshot copy_tags unless _empty? copy_tags
    DBClusterIdentifier cluster unless _empty? cluster
    DBInstanceClass instance_class
    DBInstanceIdentifier instance_id unless _empty? instance_id
    DBName db_name unless _empty? db_name
    DBParameterGroupName parameter unless _empty? parameter
    DBSecurityGroups db_security_groups unless _empty? db_security_groups
    DBSnapshotIdentifier snapshot unless _empty? snapshot
    DBSubnetGroupName subnet unless _empty? subnet
    Domain domain unless _empty? domain
    DomainIAMRoleName domain_iam unless _empty? domain_iam
    Engine engine
    EngineVersion engine_version
    Iops iops unless _empty? iops
    KmsKeyId kms unless _empty? kms
    LicenseModel license unless _empty? license
    MasterUsername user_name unless _empty? user_name
    MasterUserPassword user_password unless _empty? user_password
    MultiAZ multi_az unless _empty? multi_az
    OptionGroupName option unless _empty? option
    Port port unless _empty? port
    PreferredBackupWindow backup_window unless _empty? backup_window
    PreferredMaintenanceWindow maintenance unless _empty? maintenance
    PubliclyAccessible publicly
    SourceDBInstanceIdentifier source_db unless _empty? source_db
    StorageEncrypted encrypted unless _empty? kms
    StorageType storage_type unless _empty? storage_type
    Tags tags
    Timezone timezone unless _empty? timezone
    VPCSecurityGroups security_groups unless _empty? security_groups
  end
  DependsOn depends unless _empty? depends
end
