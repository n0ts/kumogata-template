require 'abstract_unit'

class IamAccessKeyTest < Minitest::Test
  def test_normal
    template = <<-EOS
_iam_access_key "test", user: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestAccessKey": {
    "Type": "AWS::IAM::AccessKey",
    "Properties": {
      "Status": "Active",
      "UserName": "test"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
