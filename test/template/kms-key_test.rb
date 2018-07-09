require 'abstract_unit'

class KmsKeyTest < Minitest::Test
  def test_normal
    template = <<-EOS
_kms_key "test", { policy: [ { service: "s3" } ] }
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestKmsKey": {
    "Type": "AWS::KMS::Key",
    "Properties": {
      "Description": "test kms key description",
      "Enabled": "true",
      "EnableKeyRotation": "false",
      "KeyPolicy": {
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
