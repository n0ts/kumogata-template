require 'abstract_unit'

class OutputVpcTest < Minitest::Test
  def test_normal
    template = <<-EOS
_output_vpc "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestVpc": {
    "Description": "description of TestVpc",
    "Value": {
      "Ref": "TestVpc"
    }
  },
  "TestVpcCidrBlock": {
    "Description": "description of TestVpcCidrBlock",
    "Value": {
      "Fn::GetAtt": [
        "TestVpc",
        "CidrBlock"
      ]
    }
  },
  "TestVpcNetworkAcl": {
    "Description": "description of TestVpcNetworkAcl",
    "Value": {
      "Fn::GetAtt": [
        "TestVpc",
        "DefaultNetworkAcl"
      ]
    }
  },
  "TestVpcSecurityGroup": {
    "Description": "description of TestVpcSecurityGroup",
    "Value": {
      "Fn::GetAtt": [
        "TestVpc",
        "DefaultSecurityGroup"
      ]
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
