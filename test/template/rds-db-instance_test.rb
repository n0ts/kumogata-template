require 'abstract_unit'

class RdsDbInstanceTest < Minitest::Test
  def test_normal
    template = <<-EOS
_rds_db_instance "test",
                 ref_db_name: "test",
                 ref_port: "test",
                 ref_subnet: "test",
                 ref_security_groups: "test",
                 ref_user_name: "test",
                 ref_user_password: "test",
                 az: "test"
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
            {
              "Ref": "Name"
            }
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
      "MonitoringInterval": "0",
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

  def test_single_master
    template = <<-EOS
_rds_db_instance 'test',
                 instance_class: 'db.t2.micro',
                 engine: 'mysql', engine_version: '5.7.17',
                 ref_db_name: 'test',
                 ref_subnet: 'test',
                 ref_security_groups: %w( test ),
                 ref_port: 'test',
                 ref_user_name: 'test',
                 ref_user_password: 'test'
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
      "BackupRetentionPeriod": "7",
      "DBInstanceClass": "db.t2.micro",
      "DBInstanceIdentifier": {
        "Fn::Join": [
          "-",
          [
            {
              "Ref": "Service"
            },
            {
              "Ref": "Name"
            }
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
      "MonitoringInterval": "0",
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

  def test_cluster
    template = <<-EOS
_rds_db_instance 'test cluster',
                  engine: 'aurora',
                  instance_class: 'db.t2.medium',
                  ref_cluster: 'test'
EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestClusterDbInstance": {
    "Type": "AWS::RDS::DBInstance",
    "Properties": {
      "AllowMajorVersionUpgrade": "true",
      "AutoMinorVersionUpgrade": "true",
      "DBClusterIdentifier": {
        "Ref": "TestDbCluster"
      },
      "DBInstanceClass": "db.t2.medium",
      "DBInstanceIdentifier": {
        "Fn::Join": [
          "-",
          [
            {
              "Ref": "Service"
            },
            {
              "Ref": "Name"
            }
          ]
        ]
      },
      "DBParameterGroupName": "default.aurora5.6",
      "Engine": "aurora",
      "EngineVersion": "5.6.10a",
      "MonitoringInterval": "0",
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
                "test-cluster"
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
      ]
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_slave
    template = <<-EOS
_rds_db_instance 'test',
                 master_instance: 'master',
                  ref_port: 'test',
                 source_db: 'master',
                 instance_class: 'db.t2.micro',
                 engine: 'mysql',
                 engine_version: '5.7.17',
                 ref_security_groups: %w( test )
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
      "DBInstanceClass": "db.t2.micro",
      "DBInstanceIdentifier": {
        "Fn::Join": [
          "-",
          [
            {
              "Ref": "Service"
            },
            {
              "Ref": "Name"
            }
          ]
        ]
      },
      "DBParameterGroupName": "default.mysql5.7",
      "Engine": "mysql",
      "EngineVersion": "5.7.17",
      "MonitoringInterval": "0",
      "MultiAZ": "false",
      "Port": {
        "Ref": "TestDbPort"
      },
      "PreferredMaintenanceWindow": "Thu:20:30-Thu:21:00",
      "PubliclyAccessible": "false",
      "SourceDBInstanceIdentifier": "master",
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
    },
    "DependsOn": "MasterDbInstance"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_multiaz
    template = <<-EOS
_rds_db_instance 'test',
                 instance_class: 'db.t2.micro',
                 engine: 'mysql',
                 engine_version: '5.7.17',
                 ref_db_name: 'test',
                 ref_subnet: 'test',
                 ref_security_groups: %w( test ),
                 ref_user_name: 'test',
                 ref_user_password: 'test',
                 ref_port: 'test',
                 multi_az: true
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
      "BackupRetentionPeriod": "7",
      "DBInstanceClass": "db.t2.micro",
      "DBInstanceIdentifier": {
        "Fn::Join": [
          "-",
          [
            {
              "Ref": "Service"
            },
            {
              "Ref": "Name"
            }
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
      "MonitoringInterval": "0",
      "MultiAZ": "true",
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
