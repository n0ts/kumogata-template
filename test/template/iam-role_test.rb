require 'abstract_unit'

class IamRoleTest < Minitest::Test
  def test_normal
    template = <<-EOS
_iam_role "test", user: "test", service: "s3"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestRole": {
    "Type": "AWS::IAM::Role",
    "Properties": {
      "AssumeRolePolicyDocument": {
        "Version": "2012-10-17",
        "Statement": [
          {
            "Effect": "Allow",
            "Principal": {
              "Service": [
                "s3.amazonaws.com"
              ]
            },
            "Action": [
              "sts:AssumeRole"
            ]
          }
        ]
      },
      "Path": "/",
      "RoleName": {
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
  end
end
