require 'abstract_unit'

class CognitoUserPoolGroupTest < Minitest::Test
  def test_normal
    template = <<-EOS
_cognito_user_pool_group "test", ref_pool: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestUserPoolGroup": {
    "Type": "AWS::Cognito::UserPoolGroup",
    "Properties": {
      "Description": "test user pool description",
      "GroupName": {
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

