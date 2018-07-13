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
        "Ref": "TestRedshiftClusterDbName"
      },
      "MasterUsername": {
        "Ref": "TestRedshiftClusterMasterUserName"
      },
      "MasterUserPassword": {
        "Ref": "TestRedshiftClusterMasterUserPassword"
      },
      "NodeType": "dc1.large",
      "Port": "5439",
      "PreferredMaintenanceWindow": "Thu:20:45-Thu:21:15",
      "PubliclyAccessible": "false",
      "Tags": [
        {
          "Key": "Name",
          "Value": {
            "Fn::Join": [
              "-",
              [
                {
                  "Ref": "Service"
                },
                "test"
              ]
            ]
          }
        },
        {
          "Key": "Service",
          "Value": {
            "Ref": "Service"
          }
        },
        {
          "Key": "Version",
          "Value": {
            "Ref": "Version"
          }
        }
      ],
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
