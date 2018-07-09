require 'abstract_unit'

class IamManagedPolicyTest < Minitest::Test
  def test_normal
    template = <<-EOS
_iam_managed_policy "test", policy_document: [ { service: "s3" } ]
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestManagedPolicy": {
    "Type": "AWS::IAM::ManagedPolicy",
    "Properties": {
      "Description": "test managed policy description",
      "Path": "/",
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
      }
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
