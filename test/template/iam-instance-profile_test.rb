require 'abstract_unit'

class IamInstacenProfileTest < Minitest::Test
  def test_normal
    template = <<-EOS
_iam_instance_profile "test", user: "test", roles: [ "test" ]
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestInstanceProfile": {
    "Type": "AWS::IAM::InstanceProfile",
    "Properties": {
      "Path": "/",
      "Roles": [
        "test"
      ]
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
