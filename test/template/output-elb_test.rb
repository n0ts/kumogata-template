require 'abstract_unit'

class OutputElbTest < Minitest::Test
  def test_normal
    template = <<-EOS
_output_elb "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestLoadBalancer": {
    "Description": "description of TestLoadBalancer",
    "Value": {
      "Ref": "TestLoadBalancer"
    }
  },
  "TestLoadBalancerDnsName": {
    "Description": "description of TestLoadBalancerDnsName",
    "Value": {
      "Fn::GetAtt": [
        "TestLoadBalancer",
        "DNSName"
      ]
    }
  },
  "TestLoadBalancerSecurityGroupName": {
    "Description": "description of TestLoadBalancerSecurityGroupName",
    "Value": {
      "Fn::GetAtt": [
        "TestLoadBalancer",
        "SourceSecurityGroup.GroupName"
      ]
    }
  },
  "TestLoadBalancerSecuriryGroupOwner": {
    "Description": "description of TestLoadBalancerSecuriryGroupOwner",
    "Value": {
      "Fn::GetAtt": [
        "TestLoadBalancer",
        "SourceSecurityGroup.OwnerAlias"
      ]
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
