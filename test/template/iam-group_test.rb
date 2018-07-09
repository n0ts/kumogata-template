require 'abstract_unit'

class IamGroupTest < Minitest::Test
  def test_normal
    template = <<-EOS
_iam_group "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestGroup": {
    "Type": "AWS::IAM::Group",
    "Properties": {
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
      "Path": "/"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
