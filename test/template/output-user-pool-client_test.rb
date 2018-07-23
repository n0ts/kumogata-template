require 'abstract_unit'

class OutputUserPoolClientTest < Minitest::Test
  def test_normal
    template = <<-EOS
_output_user_pool_client "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestUserPoolClient": {
    "Description": "description of TestUserPoolClient",
    "Value": {
      "Ref": "TestUserPoolClient"
    }
  },
  "TestUserPoolClientSecret": {
    "Description": "description of TestUserPoolClientSecret",
    "Value": {
      "Fn::GetAtt": [
        "TestUserPoolClient",
        "ClientSecret"
      ]
    }
  },
  "TestUserPoolClientName": {
    "Description": "description of TestUserPoolClientName",
    "Value": {
      "Fn::GetAtt": [
        "TestUserPoolClient",
        "Name"
      ]
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
