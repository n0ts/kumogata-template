require 'abstract_unit'

class RdsDbClusterTest < Minitest::Test
  def test_normal
    template = <<-EOS
_rds_db_cluster "test", ref_parameter: "test", ref_subnet_group: "test", ref_db_name: "test", ref_user_name: "test", ref_user_password: "test", ref_security_groups: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestDbCluster": {
    "Type": "AWS::RDS::DBCluster",
    "Properties": {
      "BackupRetentionPeriod": "7",
      "DatabaseName": {
        "Ref": "TestDbName"
      },
      "DBClusterParameterGroupName": {
        "Ref": "TestDbClusterParameterGroup"
      },
      "DBSubnetGroupName": {
        "Ref": "TestDbSubnetGroup"
      },
      "Engine": "aurora",
      "EngineVersion": "5.6.10a",
      "MasterUsername": {
        "Ref": "TestDbMasterUserName"
      },
      "MasterUserPassword": {
        "Ref": "TestDbMasterUserPassword"
      },
      "Port": "3306",
      "PreferredBackupWindow": "21:30-22:00",
      "PreferredMaintenanceWindow": "Thu:20:30-Thu:21:00",
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
