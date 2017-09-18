require 'abstract_unit'

class Ec2NetworkInterfaceTest < Minitest::Test
  def test_normal
    template = <<-EOS
_ec2_network_interface "test", ref_subnet: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestNetworkInterface": {
    "Type": "AWS::EC2::NetworkInterface",
    "Properties": {
      "SourceDestCheck": "false",
      "SubnetId": {
        "Ref": "TestSubnet"
      },
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
