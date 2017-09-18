require 'abstract_unit'

class Ec2DhcpOptionsTest < Minitest::Test
  def test_normal
    template = <<-EOS
_ec2_dhcp_options "test", domain_name: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestDhcpOptions": {
    "Type": "AWS::EC2::DHCPOptions",
    "Properties": {
      "DomainName": "test",
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
