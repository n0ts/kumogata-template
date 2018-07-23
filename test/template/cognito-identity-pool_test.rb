require 'abstract_unit'

class CognitoIdentityPoolTest < Minitest::Test
  def test_normal
    template = <<-EOS
_cognito_identity_pool "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestIdentityPool": {
    "Type": "AWS::Cognito::IdentityPool",
    "Properties": {
      "IdentityPoolName": {
        "Fn::Join": [
          "_",
          [
            {
              "Ref": "Service"
            },
            "test"
          ]
        ]
      },
      "AllowUnauthenticatedIdentities": "false"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
