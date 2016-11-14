require 'abstract_unit'

class IamUserTest < Minitest::Test
  def test_normal
    template = <<-EOS
_iam_user "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestUser": {
    "Type": "AWS::IAM::User",
    "Properties": {
      "Path": "/",
      "UserName": "test"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
