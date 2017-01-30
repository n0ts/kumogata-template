require 'abstract_unit'

class CloudfrontDistributionTest < Minitest::Test
  def test_normal
    template = <<-EOS
_cloudfront_distribution "test", { origins: [{ domain: "test", id: "test", s3: {} }] }
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestDistribution": {
    "Type": "AWS::CloudFront::Distribution",
    "Properties": {
      "DistributionConfig": {
        "DefaultRootObject": "index.html",
        "Enabled": "true",
        "HttpVersion": "http2",
        "Origins": [
          {
            "DomainName": "test",
            "Id": "test",
            "S3OriginConfig": {
            }
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
