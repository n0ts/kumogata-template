require 'abstract_unit'

class IamUserToGroupAdditionTest < Minitest::Test
  def test_normal
    template = <<-EOS
_iam_user_to_group_addition "test", group: "test1", users: [ "test2" ]
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestUserToGroupAddition": {
    "Type": "AWS::IAM::UserToGroupAddition",
    "Properties": {
      "GroupName": "test1",
      "Users": [
        "test2"
      ]
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
