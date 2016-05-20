require 'abstract_unit'

class ElasticbeanstalkApplicationVersionTest < Minitest::Test
  def test_normal
    template = <<-EOS
_elasticbeanstalk_application_version "test", application: "test", ref_s3_bucket: "test", s3_key: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestElasticbeanstalkApplicationVersion": {
    "Type": "AWS::ElasticBeanstalk::ApplicationVersion",
    "Properties": {
      "ApplicationName": "test",
      "SourceBundle": {
        "S3Bucket": {
          "Ref": "TestBucket"
        },
        "S3Key": "test"
      }
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
