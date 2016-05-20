require 'abstract_unit'

class Ec2NetworkAclTest < Minitest::Test
  def test_normal
    template = <<-EOS
_ec2_network_acl "test", ref_vpc: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestNetworkAcl": {
    "Type": "AWS::EC2::NetworkAcl",
    "Properties": {
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
      "VpcId": {
        "Ref": "TestVpc"
      }
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
