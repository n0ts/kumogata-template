require 'abstract_unit'

class Ec2SpotFeetTest < Minitest::Test
  def test_normal
    template = <<-EOS
launches = [
  { block_devices: [ { ref_size: "test" } ],
    ref_iam: "test", image_id: "test", ref_key_name: "test", instance_type: "test", network_interfaces: [ { ref_subnet: "test" } ] }
]
_ec2_spot_fleet "test", iam: "test", price: 1000, ref_taget: "test", launches: launches, target: 1
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestSpotFleet": {
    "Type": "AWS::EC2::SpotFleet",
    "Properties": {
      "SpotFleetRequestConfigData": {
        "AllocationStrategy": "lowestPrice",
        "IamFleetRole": "test",
        "LaunchSpecifications": [
          {
            "BlockDeviceMappings": [
              {
                "DeviceName": "/dev/sdb",
                "Ebs": {
                  "DeleteOnTermination": "true",
                  "VolumeSize": {
                    "Ref": "TestVolumeSize"
                  },
                  "VolumeType": "gp2"
                }
              }
            ],
            "EbsOptimized": "false",
            "IamInstanceProfile": {
              "Arn": {
                "Ref": "TestIamInstanceProfile"
              }
            },
            "ImageId": "test",
            "InstanceType": "test",
            "KeyName": {
              "Ref": "TestKeyName"
            },
            "Monitoring": {
              "Enabled": "false"
            },
            "NetworkInterfaces": [
              {
                "AssociatePublicIpAddress": "true",
                "DeleteOnTermination": "true",
                "DeviceIndex": "0",
                "SubnetId": {
                  "Ref": "TestSubnet"
                }
              }
            ]
          }
        ],
        "SpotPrice": "1000",
        "TargetCapacity": "1",
        "TerminateInstancesWithExpiration": "false"
      }
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_aws
    template = <<-EOS
launches = [
  { ebs: false, ref_instance_type: "test", image: "test", ref_subnet: "subnet1", weighted: 8 },
  { ebs: true, ref_instance_type: "test", image: "test", ref_subnet: "subnet0", weighted: 8, monitoring: true, ref_security_groups: [ "test" ], ref_iam: "root" },
]
_ec2_spot_fleet "test", iam: "test", price: 1000, ref_target: "target capacity", launches: launches
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestSpotFleet": {
    "Type": "AWS::EC2::SpotFleet",
    "Properties": {
      "SpotFleetRequestConfigData": {
        "AllocationStrategy": "lowestPrice",
        "IamFleetRole": "test",
        "LaunchSpecifications": [
          {
            "EbsOptimized": "false",
            "ImageId": {
              "Fn::FindInMap": [
                "AWSRegionArch2AMITest",
                {
                  "Ref": "AWS::Region"
                },
                {
                  "Fn::FindInMap": [
                    "AWSInstanceType2Arch",
                    {
                      "Ref": "TestInstanceType"
                    },
                    "Arch"
                  ]
                }
              ]
            },
            "InstanceType": {
              "Ref": "TestInstanceType"
            },
            "Monitoring": {
              "Enabled": "false"
            },
            "SubnetId": {
              "Ref": "Subnet1Subnet"
            },
            "WeightedCapacity": "8"
          },
          {
            "EbsOptimized": "true",
            "IamInstanceProfile": {
              "Arn": {
                "Ref": "RootIamInstanceProfile"
              }
            },
            "ImageId": {
              "Fn::FindInMap": [
                "AWSRegionArch2AMITest",
                {
                  "Ref": "AWS::Region"
                },
                {
                  "Fn::FindInMap": [
                    "AWSInstanceType2Arch",
                    {
                      "Ref": "TestInstanceType"
                    },
                    "Arch"
                  ]
                }
              ]
            },
            "InstanceType": {
              "Ref": "TestInstanceType"
            },
            "Monitoring": {
              "Enabled": "true"
            },
            "SecurityGroups": [
              {
                "Ref": "TestSecurityGroup"
              }
            ],
            "SubnetId": {
              "Ref": "Subnet0Subnet"
            },
            "WeightedCapacity": "8"
          }
        ],
        "SpotPrice": "1000",
        "TargetCapacity": {
          "Ref": "TargetCapacity"
        },
        "TerminateInstancesWithExpiration": "false"
      }
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
