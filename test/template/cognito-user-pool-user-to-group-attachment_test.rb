require 'abstract_unit'

class CognitoUserPoolUserToGroupAttachmentTest < Minitest::Test
  def test_normal
    template = <<-EOS
_cognito_user_pool_user_to_group_attachment "test", ref_user: "test", ref_group: "test", ref_pool: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestUserPoolUserToGroupAttachment": {
    "Type": "AWS::Cognito::UserPoolUserToGroupAttachment",
    "Properties": {
      "GroupName": {
        "Ref": "TestUserPoolGroup"
      },
      "Username": {
        "Ref": "TestUserPoolUser"
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
