require 'abstract_unit'

class OutputEc2Test < Minitest::Test
  def test_normal
    template = <<-EOS
_output_ec2 "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestInstance": {
    "Description": "description of TestInstance",
    "Value": {
      "Ref": "TestInstance"
    }
  },
  "TestInstanceAz": {
    "Description": "description of TestInstanceAz",
    "Value": {
      "Fn::GetAtt": [
        "TestInstance",
        "AvailabilityZone"
      ]
    }
  },
  "TestInstancePrivateIp": {
    "Description": "description of TestInstancePrivateIp",
    "Value": {
      "Fn::GetAtt": [
        "TestInstance",
        "PrivateIp"
      ]
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
_output_ec2 "test", public_ip: true
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestInstance": {
    "Description": "description of TestInstance",
    "Value": {
      "Ref": "TestInstance"
    }
  },
  "TestInstanceAz": {
    "Description": "description of TestInstanceAz",
    "Value": {
      "Fn::GetAtt": [
        "TestInstance",
        "AvailabilityZone"
      ]
    }
  },
  "TestInstancePublicIp": {
    "Description": "description of TestInstancePublicIp",
    "Value": {
      "Fn::GetAtt": [
        "TestInstance",
        "PublicIp"
      ]
    }
  },
  "TestInstancePrivateIp": {
    "Description": "description of TestInstancePrivateIp",
    "Value": {
      "Fn::GetAtt": [
        "TestInstance",
        "PrivateIp"
      ]
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
