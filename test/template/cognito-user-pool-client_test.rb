require 'abstract_unit'

class CognitoUserPoolClientTest < Minitest::Test
  def test_normal
    template = <<-EOS
_cognito_user_pool_client "test", ref_pool: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestUserPoolClient": {
    "Type": "AWS::Cognito::UserPoolClient",
    "Properties": {
      "ClientName": {
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
      "GenerateSecret": "false",
      "RefreshTokenValidity": "30",
      "UserPoolId": {
        "Ref": "TestUserPool"
      }
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
