require 'abstract_unit'

class EmrSecurityConfigurationTest < Minitest::Test
  def test_normal
    template = <<-EOS
_emr_security_configuration "test", configuration: { test: "test1" }
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestEmrSecurityConfiguration": {
    "Type": "AWS::EMR::SecurityConfiguration",
    "Properties": {
      "Name": {
        "Fn::Join": [
          "-",
          [
            {
              "Ref": "Service"
            },
            "test"
          ]
        ]
      },
      "SecurityConfiguration": {
        "test": "test1"
      }
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
