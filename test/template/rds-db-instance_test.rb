require 'abstract_unit'

class RdsDbInstanceTest < Minitest::Test
  def test_normal
    template = <<-EOS
_rds_db_instance "test", ref_db_name: "test", ref_port: "test", ref_subnet_group: "test", ref_security_groups: "test", ref_user_name: "test", ref_user_password: "test", az: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestDbInstance": {
    "Type": "AWS::RDS::DBInstance",
    "Properties": {
      "AllocatedStorage": "5",
      "AllowMajorVersionUpgrade": "true",
      "AutoMinorVersionUpgrade": "true",
      "AvailabilityZone": "test",
      "BackupRetentionPeriod": "7",
      "DBInstanceClass": "db.t2.medium",
      "DBInstanceIdentifier": {
        "Fn::Join": [
          "-",
          [
            {
              "Ref": "Service"
            },
            "test"
          ]
        ]
      },
      "DBName": {
        "Ref": "TestDbName"
      },
      "DBParameterGroupName": "default.mysql5.7",
      "DBSubnetGroupName": {
        "Ref": "TestDbSubnetGroup"
      },
      "Engine": "mysql",
      "EngineVersion": "5.7.17",
      "MasterUsername": {
        "Ref": "TestDbMasterUserName"
      },
      "MasterUserPassword": {
        "Ref": "TestDbMasterUserPassword"
      },
      "MultiAZ": "false",
      "Port": {
        "Ref": "TestDbPort"
      },
      "PreferredBackupWindow": "21:30-22:00",
      "PreferredMaintenanceWindow": "Thu:20:30-Thu:21:00",
      "PubliclyAccessible": "false",
      "StorageType": "gp2",
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
      "VPCSecurityGroups": [
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
