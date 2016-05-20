require 'abstract_unit'

class RedshiftClusterTest < Minitest::Test
  def test_normal
    template = <<-EOS
_redshift_cluster "test", ref_db_name: "test", ref_parameter: "test", ref_subnet: "test", ref_user_name: "test", ref_user_password: "test", ref_security_groups: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestRedshiftCluster": {
    "Type": "AWS::Redshift::Cluster",
    "Properties": {
      "AllowVersionUpgrade": "true",
      "AutomatedSnapshotRetentionPeriod": "10",
      "ClusterParameterGroupName": {
        "Ref": "TestRedshiftClusterParameterGroup"
      },
      "ClusterSubnetGroupName": {
        "Ref": "TestRedshiftClusterSubnetGroup"
      },
      "ClusterType": "single-node",
      "DBName": {
        "Ref": "TestDbName"
      },
      "MasterUsername": {
        "Ref": "TestClusterMasterUserName"
      },
      "MasterUserPassword": {
        "Ref": "TestClusterMasterUserPassword"
      },
      "NodeType": "ds1.xlarge",
      "Port": "5439",
      "PreferredMaintenanceWindow": "Thu:20:45-Thu:21:15",
      "PubliclyAccessible": "false",
      "VpcSecurityGroupIds": [
        {
          "Ref": "TestSecurityGroup"
        }
      ]
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
