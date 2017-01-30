require 'abstract_unit'
require 'kumogata/template/cloudfront'

class CloudFrontTest < Minitest::Test
  def test_cloudfront_distribution_config
    template = <<-EOS
Test _cloudfront_distribution_config({ origins: [{ domain: "test", id: "test", s3: {} }] })
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
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
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_cloudfront_cache_behavior
    template = <<-EOS
Test _cloudfront_cache_behavior({ forwarded: {}, path: "test", target: "test", viewer: "test" })
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "ForwardedValues": {
      "QueryString": "false"
    },
    "PathPattern": "test",
    "TargetOriginId": "test",
    "ViewerProtocolPolicy": "redirect-to-https"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_cloudfront_forwared_cookies
    template = <<-EOS
Test _cloudfront_forwared_cookies({ forward: "test", white_lists: "test" })
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Forward": "test",
    "WhitelistedNames": "test"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_cloudfront_forwarded_values
    template = <<-EOS
Test _cloudfront_forwarded_values({})
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "QueryString": "false"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_cloudfront_custom_error
    template = <<-EOS
Test _cloudfront_custom_error({})
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "ErrorCode": "404",
    "ResponseCode": "404",
    "ResponsePagePath": "/404.html"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_cloudfront_custom_errors
    template = <<-EOS
Test _cloudfront_custom_errors([ {} ])
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": [
    {
      "ErrorCode": "404",
      "ResponseCode": "404",
      "ResponsePagePath": "/404.html"
    }
  ]
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_cloudfront_logging
    template = <<-EOS
Test _cloudfront_logging({ bucket: "test" })
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Bucket": "test"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_cloudfront_origin
    template = <<-EOS
Test _cloudfront_origin({ domain: "test", id: "test", s3: {} })
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "DomainName": "test",
    "Id": "test",
    "S3OriginConfig": {
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_cloudfront_origins
    template = <<-EOS
Test _cloudfront_origins([ { domain: "test1", id: "test1", s3: {} },
                           { domain: "test2", id: "test2", s3: {} } ])
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": [
    {
      "DomainName": "test1",
      "Id": "test1",
      "S3OriginConfig": {
      }
    },
    {
      "DomainName": "test2",
      "Id": "test2",
      "S3OriginConfig": {
      }
    }
  ]
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_cloudfront_custom_origin
    template = <<-EOS
Test _cloudfront_custom_origin({})
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_cloudfront_s3_origin
    template = <<-EOS
Test _cloudfront_s3_origin({})
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_cloudfront_custom_origin
    template = <<-EOS
Test _cloudfront_custom_origin({})
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_cloudfront_s3_origin
    template = <<-EOS
Test _cloudfront_s3_origin({})
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end


  def test_cloudfront_origin_headers
    template = <<-EOS
Test _cloudfront_origin_headers({ name: "test", value: "test" })
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "HeaderName": "test",
    "HeaderValue": "test"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_cloudfront_viewer_cert
    template = <<-EOS
Test _cloudfront_viewer_cert({ acm: "test" })
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "AcmCertificateArn": "test",
    "SslSupportMethod": "sni-only"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
