require 'abstract_unit'

class OutputRestApiTest < Minitest::Test
  def test_normal
    template = <<-EOS
_output_rest_api "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestRestApi": {
    "Description": "description of TestRestApi",
    "Value": {
      "Ref": "TestRestApi"
    }
  },
  "TestRestApiRootResource": {
    "Description": "description of TestRestApiRootResource",
    "Value": {
      "Fn::GetAtt": [
        "TestRestApi",
        "RootResourceId"
      ]
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
