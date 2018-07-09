require 'abstract_unit'

class ElasticbeanstalkApplicationVersionTest < Minitest::Test
  def test_normal
    template = <<-EOS
_elasticbeanstalk_application_version "test", application: "test", ref_s3_bucket: "test", s3_key: "test.war"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestElasticbeanstalkApplicationVersion": {
    "Type": "AWS::ElasticBeanstalk::ApplicationVersion",
    "Properties": {
      "ApplicationName": "test",
      "Description": "test elasticbeanstalk application version description",
      "SourceBundle": {
        "S3Bucket": {
          "Fn::Join": [
            "-",
            [
              {
                "Ref": "TestBucket"
              },
              {
                "Ref": "AWS::Region"
              }
            ]
          ]
        },
        "S3Key": "test.war"
      }
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
