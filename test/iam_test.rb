require 'abstract_unit'
require 'kumogata/template/iam'

class IamTest < Minitest::Test
  def test_iam_policies
    template = <<-EOS
Policies _iam_policies "test", test: [ { document: [ { service: "s3" } ] } ]
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Policies": [
    {
      "PolicyDocument": [
        {
          "Effect": "Allow",
          "Action": [
            "s3:*"
          ],
          "Resource": [
            "*"
          ]
        }
      ],
      "PolicyName": "Policy0"
    }
  ]
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_iam_policy_document
    template = <<-EOS
PolicyDocument _iam_policy_document "test", test: [ { service: "s3" } ]
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "PolicyDocument": [
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
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_iam_assume_role_policy_document
    template = <<-EOS
Statement _iam_assume_role_policy_document("ec2")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "ec2.amazonaws.com"
        ]
      },
      "Action": [
        "sts:AssumeRole"
      ]
    }
  ]
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_iam_arn
    template = <<-EOS
arn _iam_arn("s3", "test")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "arn": "arn:aws:s3:::test"
}
  EOS
    assert_equal exp_template.chomp, act_template
  end
end
