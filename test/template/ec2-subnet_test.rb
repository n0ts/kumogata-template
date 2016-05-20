require 'abstract_unit'

class Ec2SubnetTest < Minitest::Test
  def test_normal
    template = <<-EOS
_ec2_subnet "test", vpc: "test"
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
end
