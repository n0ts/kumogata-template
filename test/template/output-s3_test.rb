require 'abstract_unit'

class OutputS3Test < Minitest::Test
  def test_normal
    template = <<-EOS
_output_s3 "test", domain: true
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestBucketS3Arn": {
    "Description": "description of TestBucketS3Arn",
    "Value": {
      "Fn::GetAtt": [
        "TestBucket",
        "Arn"
      ]
    }
  },
  "TestBucketS3DomainName": {
    "Description": "description of TestBucketS3DomainName",
    "Value": {
      "Fn::GetAtt": [
        "TestBucket",
        "DomainName"
      ]
    }
  },
  "TestBucketS3WebSiteUrl": {
    "Description": "description of TestBucketS3WebSiteUrl",
    "Value": {
      "Fn::GetAtt": [
        "TestBucket",
        "WebsiteURL"
      ]
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
