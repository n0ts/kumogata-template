require 'abstract_unit'

class OutputUserPoolTest < Minitest::Test
  def test_normal
    template = <<-EOS
_output_user_pool "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestUserPool": {
    "Description": "description of TestUserPool",
    "Value": {
      "Ref": "TestUserPool"
    }
  },
  "TestUserPoolProviderName": {
    "Description": "description of TestUserPoolProviderName",
    "Value": {
      "Fn::GetAtt": [
        "TestUserPool",
        "ProviderName"
      ]
    }
  },
  "TestUserPoolProviderUrl": {
    "Description": "description of TestUserPoolProviderUrl",
    "Value": {
      "Fn::GetAtt": [
        "TestUserPool",
        "ProviderURL"
      ]
    }
  },
  "TestUserPoolArn": {
    "Description": "description of TestUserPoolArn",
    "Value": {
      "Fn::GetAtt": [
        "TestUserPool",
        "Arn"
      ]
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
