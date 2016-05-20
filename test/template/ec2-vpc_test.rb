require 'abstract_unit'

class Ec2VpcTest < Minitest::Test
  def test_normal
    template = <<-EOS
_ec2_vpc "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestVpc": {
    "Type": "AWS::EC2::VPC",
    "Properties": {
      "CidrBlock": "191.168.1.0/16",
      "EnableDnsSupport": "true",
      "EnableDnsHostnames": "true",
      "InstanceTenancy": "default",
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
      ]
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_aws
    template = <<-EOS
_ec2_vpc "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestVpc": {
    "Type": "AWS::EC2::VPC",
    "Properties": {
      "CidrBlock": "191.168.1.0/16",
      "EnableDnsSupport": "true",
      "EnableDnsHostnames": "true",
      "InstanceTenancy": "default",
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
      ]
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end

