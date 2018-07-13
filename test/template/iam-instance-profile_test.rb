require 'abstract_unit'

class IamInstacenProfileTest < Minitest::Test
  def test_normal
    template = <<-EOS
_iam_instance_profile "test", roles: [ "test" ]
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
      ],
      "InstanceProfileName": {
        "Fn::Join": [
          "-",
          [
            {
              "Ref": "Service"
            },
            "test"
          ]
        ]
      }
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
_iam_instance_profile "test", profile: "test", roles: [ "test" ], profile_name: "test"
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
      ],
      "InstanceProfileName": "test"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
