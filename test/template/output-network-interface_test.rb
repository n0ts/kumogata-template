require 'abstract_unit'

class OutputNetworkInterfaceTest < Minitest::Test
  def test_normal
    template = <<-EOS
_output_network_interface "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestNetworkInterface": {
    "Description": "description of TestNetworkInterface",
    "Value": {
      "Ref": "TestNetworkInterface"
    }
  },
  "TestNetworkInterfacePrivateIp": {
    "Description": "description of TestNetworkInterfacePrivateIp",
    "Value": {
      "Fn::GetAtt": [
        "TestNetworkInterface",
        "PrimaryPrivateIpAddress"
      ]
    }
  },
  "TestNetworkInterfaceSecondaryIps": {
    "Description": "description of TestNetworkInterfaceSecondaryIps",
    "Value": {
      "Fn::GetAtt": [
        "TestNetworkInterface",
        "SecondaryPrivateIpAddresses"
      ]
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
