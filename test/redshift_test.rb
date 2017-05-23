require 'abstract_unit'
require 'kumogata/template/redshift'

class RedshiftTest < Minitest::Test
  def test_redshift_parameters
    template = <<-EOS
parameters = { name: "wlm_json_configuration", value: [ { test: "test" } ] }
Test _redshift_parameters(parameters: [ parameters ])
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": [
    {
      "ParameterName": "wlm_json_configuration",
      "ParameterValue": "[{\\"test\\":\\"test\\"}]"
    }
  ]
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
