require 'abstract_unit'

class Ec2CustomerGatewayTest < Minitest::Test
  def test_normal
    template = <<-EOS
_ec2_customer_gateway "test", ref_bgp: "test", ref_ip: "test", type: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestCustomerGateway": {
    "Type": "AWS::EC2::CustomerGateway",
    "Properties": {
      "BgpAsn": {
        "Ref": "TestBgp"
      },
      "IpAddress": {
        "Ref": "TestIp"
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
      ],
      "Type": "test"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
