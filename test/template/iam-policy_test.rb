require 'abstract_unit'

class IamPolicyTest < Minitest::Test
  def test_normal
    template = <<-EOS
_iam_policy "test", user: "test", ref_roles: "test", policy_document: [ { service: "s3" } ]
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestPolicy": {
    "Type": "AWS::IAM::Policy",
    "Properties": {
      "PolicyDocument": {
        "Version": "2012-10-17",
        "Statement": [
          {
            "Effect": "Allow",
            "Action": [
              "s3:*"
            ],
            "Resource": [
              "*"
            ]
          }
        ]
      },
      "PolicyName": {
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
      "Roles": [
        {
          "Ref": "TestRole"
        }
      ]
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
