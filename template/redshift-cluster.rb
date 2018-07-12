#
# Redshift cluster resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-redshift-cluster.html
#
require 'kumogata/template/helper'
require 'kumogata/template/redshift'

name = _resource_name(args[:name], "redshift cluster")
allow = _bool("allow", args, true)
snapshot_retention = args[:snapshot_retention] || DEFAULT_SNAPSHOT_NUM
az = _availability_zone(args, false, "redshift cluster zone name")
parameter = _ref_string("parameter", args, "redshift cluster parameter group")
subnet = _ref_string("subnet", args, "redshift cluster subnet group")
num = args[:num] || 1
type = (num == 1) ? "single-node" : "multi-node"
version = args[:version] || ""
db_name = _ref_string("db_name", args, "redshift cluster db name")
elastic = args[:elastic] || ""
encrypted = _bool("encrypted", args, false)
roles = _ref_array("roles", args, "role", "Arn")
logging = _redshift_logging(args)
user_name = _ref_string("user_name", args, "redshift cluster master user name")
user_password = _ref_string("user_password", args, "redshift cluster master user password")
node = _ref_string_default("node", args, "redshift cluster node types", REDSHIFT_DEFAULT_NODE_TYPE)
owner = args[:owner] || ""
port = _ref_string_default("port", args, "redshift cluster port", PORT[:redshift])
maintenance = _maintenance_window("redshift", args[:maintenance] || DEFAULT_MAINTENANCE_TIME[:redshift])
publicly = _bool("publicly", args, false)
snapshot_cluster = args[:snapshot_cluster] || ""
snapshot_id = args[:snapshot_id] || ""
tags = _tags(args)
security_groups = _ref_array("security_groups", args, "security group")

_(name) do
  Type "AWS::Redshift::Cluster"
  Properties do
    AllowVersionUpgrade allow
    AutomatedSnapshotRetentionPeriod snapshot_retention
    AvailabilityZone az unless az.empty?
    ClusterParameterGroupName parameter unless parameter.empty?
    #ClusterSecurityGroups
    ClusterSubnetGroupName subnet unless subnet.empty?
    ClusterType type
    ClusterVersion version unless version.empty?
    DBName db_name
    ElasticIp elastic unless elastic.empty?
    Encrypted encrypted if encrypted == true
    #HsmClientCertificateIdentifie
    #HsmConfigurationIdentifier
    IamRoles roles unless roles .empty?
    #KmsKeyId
    LoggingProperties logging unless logging.empty?
    MasterUsername user_name
    MasterUserPassword user_password
    NodeType node
    NumberOfNodes num if type == "multi-node"
    OwnerAccount owner unless owner.empty?
    Port port
    PreferredMaintenanceWindow maintenance
    PubliclyAccessible publicly
    SnapshotClusterIdentifier  snapshot_cluster unless snapshot_cluster.empty?
    SnapshotIdentifier snapshot_id unless snapshot_id.empty?
    Tags tags
    VpcSecurityGroupIds security_groups unless security_groups.empty?
  end
end
