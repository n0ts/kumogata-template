require 'abstract_unit'

class ParameterEc2Test < Minitest::Test
  def test_normal
    template = <<-EOS
_parameter_ec2 "test"
    EOS
    act_template = run_client_as_json(template)
    values = JSON.generate(EC2_INSTANCE_TYPES)
                       .gsub("[", "[\n      ")
                       .gsub("\",", "\",\n      ")
                       .gsub("\"]", "\"\n    ]")
    exp_template = <<-EOS
{
  "TestInstanceType": {
    "Type": "String",
    "Default": "#{EC2_DEFAULT_INSTANCE_TYPE}",
    "Description": "test instance type",
    "AllowedValues": #{values},
    "NoEcho": "false"
  },
  "TestRootVolumeSize": {
    "Type": "Number",
    "Default": "8",
    "Description": "test root volume size",
    "NoEcho": "false"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
_parameter_ec2 "test", iam_instance: "test", key_name: "test"
    EOS
    act_template = run_client_as_json(template)
    values = JSON.generate(EC2_INSTANCE_TYPES)
                       .gsub("[", "[\n      ")
                       .gsub("\",", "\",\n      ")
                       .gsub("\"]", "\"\n    ]")
    exp_template = <<-EOS
{
  "TestInstanceType": {
    "Type": "String",
    "Default": "#{EC2_DEFAULT_INSTANCE_TYPE}",
    "Description": "test instance type",
    "AllowedValues": #{values},
    "NoEcho": "false"
  },
  "TestIamInstanceProfile": {
    "Type": "String",
    "Default": "test",
    "Description": "test iam instance profile",
    "NoEcho": "false"
  },
  "TestRootVolumeSize": {
    "Type": "Number",
    "Default": "8",
    "Description": "test root volume size",
    "NoEcho": "false"
  },
  "TestKeyName": {
    "Type": "AWS::EC2::KeyPair::KeyName",
    "Default": "test",
    "Description": "test key name",
    "NoEcho": "false"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
