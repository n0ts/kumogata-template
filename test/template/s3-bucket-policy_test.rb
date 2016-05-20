require 'abstract_unit'

class S3BucketPolicyTest < Minitest::Test
  def test_normal
    template = <<-EOS
policy = {}
_s3_bucket_policy "test", policy_document: policy
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestBucketPolicy": {
    "Type": "AWS::S3::BucketPolicy",
    "Properties": {
      "BucketName": {
        "Fn::Join": [
          "-",
          [
            {
              "Ref": "Service"
            },
            {
              "Ref": "Name"
            }
          ]
        ]
      },
      "PolicyDocument": {
        "Version": "2012-10-17",
        "Statement": [

        ]
      }
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
