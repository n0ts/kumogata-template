require 'abstract_unit'

class Ec2SubnetTest < Minitest::Test
  def test_normal
    template = <<-EOS
_ec2_subnet "test", { vpc: "test" }
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestSubnet": {
    "Type": "AWS::EC2::Subnet",
    "Properties": {
      "CidrBlock": "10.1.0.0/24",
      "MapPublicIpOnLaunch": "true",
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
      "VpcId": "test"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_association
    template = <<-EOS
name = "test test"
_ec2_subnet name, { vpc: "test" }
_ec2_subnet_route_table_association name, ref_route_table: name, ref_subnet: name
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestTestSubnet": {
    "Type": "AWS::EC2::Subnet",
    "Properties": {
      "CidrBlock": "10.1.0.0/24",
      "MapPublicIpOnLaunch": "true",
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
                "test-test"
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
      "VpcId": "test"
    }
  },
  "TestTestSubnetRouteTableAssociation": {
    "Type": "AWS::EC2::SubnetRouteTableAssociation",
    "Properties": {
      "RouteTableId": {
        "Ref": "TestTestRouteTable"
      },
      "SubnetId": {
        "Ref": "TestTestSubnet"
      }
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
