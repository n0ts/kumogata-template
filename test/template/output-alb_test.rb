require 'abstract_unit'

class OutputAlbTest < Minitest::Test
  def test_normal
    template = <<-EOS
_output_alb "test"
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
  "TestLoadBalancerFullName": {
    "Description": "description of TestLoadBalancerFullName",
    "Value": {
      "Fn::GetAtt": [
        "TestLoadBalancer",
        "LoadBalancerFullName"
      ]
    }
  },
  "TestLoadBalancerName": {
    "Description": "description of TestLoadBalancerName",
    "Value": {
      "Fn::GetAtt": [
        "TestLoadBalancer",
        "LoadBalancerName"
      ]
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
_output_alb "test", security_groups: 1
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
  "TestLoadBalancerFullName": {
    "Description": "description of TestLoadBalancerFullName",
    "Value": {
      "Fn::GetAtt": [
        "TestLoadBalancer",
        "LoadBalancerFullName"
      ]
    }
  },
  "TestLoadBalancerName": {
    "Description": "description of TestLoadBalancerName",
    "Value": {
      "Fn::GetAtt": [
        "TestLoadBalancer",
        "LoadBalancerName"
      ]
    }
  },
  "TestLoadBalancerSecurityGroup0": {
    "Description": "description of TestLoadBalancerSecurityGroup0",
    "Value": {
      "Fn::Select": [
        "0",
        {
          "Fn::GetAtt": [
            "TestLoadBalancer",
            "SecurityGroups"
          ]
        }
      ]
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
