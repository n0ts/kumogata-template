require 'abstract_unit'

class CognitoUserPoolUserTest < Minitest::Test
  def test_normal
    template = <<-EOS
_cognito_user_pool_user "test", ref_pool: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestUserPoolUser": {
    "Type": "AWS::Cognito::UserPoolUser",
    "Properties": {
      "DesiredDeliveryMediums": [
        "SMS"
      ],
      "ForceAliasCreation": "false",
      "Username": {
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
