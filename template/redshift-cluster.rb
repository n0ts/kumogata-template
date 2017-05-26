#
# Redshift cluster resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-redshift-cluster.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "redshift cluster")
allow = _bool("allow", args, true)
snapshot_retention = args[:snapshot_retention] || DEFAULT_SNAPSHOT_NUM
az = _availability_zone(args, false)
parameter = _ref_string("parameter", args, "redshift cluster parameter group")
subnet = _ref_string("subnet", args, "redshift cluster subnet group")
type = _valid_values(args[:type], [ "single-node", "multi-node" ], "single-node")
version = args[:version] || ""
db_name = _ref_string("db_name", args, "db name")
elastic = args[:elastic] || ""
encrypted = _bool("encrypted", args, false)
iam_role = args[:iam_role] || ""
user_name = _ref_string("user_name", args, "cluster master user name")
user_password = _ref_string("user_password", args, "cluster master user password")
node = _ref_string("node", args, "redshift cluster node types")
node = _valid_values(args[:node], REDSHIFT_NODE_TYPES, REDSHIFT_DEFAULT_NODE_TYPE) unless node.is_a? Hash
num = args[:num] || 1
owner = args[:owner] || ""
port = _ref_string("port", args, "cluster port")
port = PORT[:redshift] if port.empty?
maintenance = _maintenance_window("redshift", args[:maintenance] || DEFAULT_MAINTENANCE_TIME[:redshift])
publicly = _bool("publicly", args, false)
snapshot_cluster = args[:snapshot_cluster] || ""
snapshot_id = args[:snapshot_id] || ""
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
    IamRoles iam_role unless iam_role.empty?
    #KmsKeyId
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
    VpcSecurityGroupIds security_groups unless security_groups.empty?
  end
end
