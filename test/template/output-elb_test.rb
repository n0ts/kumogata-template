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

    template = <<-EOS
_output_elb "test", route53: true
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
  "TestLoadBalancerCanonicalHostedZoneName": {
    "Description": "description of TestLoadBalancerCanonicalHostedZoneName",
    "Value": {
      "Fn::GetAtt": [
        "TestLoadBalancer",
        "CanonicalHostedZoneName"
      ]
    }
  },
  "TestLoadBalancerCanonicalHostedZoneId": {
    "Description": "description of TestLoadBalancerCanonicalHostedZoneId",
    "Value": {
      "Fn::GetAtt": [
        "TestLoadBalancer",
        "CanonicalHostedZoneID"
      ]
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
