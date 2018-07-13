require 'abstract_unit'

class CognitoIdentityRoleAttachmentTest < Minitest::Test
  def test_normal
    template = <<-EOS
_cognito_identity_role_attachment "test", ref_pool: "test",
                                  roles: { ref_unauth: "test unauth", ref_auth: "test auth" }
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestIdentityPoolRoleAttachment": {
    "Type": "AWS::Cognito::IdentityPoolRoleAttachment",
    "Properties": {
      "IdentityPoolId": {
        "Ref": "TestIdentityPool"
      },
      "Roles": {
        "unauthenticated": {
          "Fn::GetAtt": [
            "TestUnauthRole",
            "Arn"
          ]
        },
        "authenticated": {
          "Fn::GetAtt": [
            "TestAuthRole",
            "Arn"
          ]
        }
      }
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
