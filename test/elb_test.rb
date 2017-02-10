require 'abstract_unit'
require 'kumogata/template/elb'

class ElbTest < Minitest::Test
  def test_elb_acccess_logging_policy
    template = <<-EOS
Test _elb_access_logging_policy(access_logging: { s3_bucket: "test", s3_bucket_prefix: "test" })
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "EmitInterval": "5",
    "Enabled": "true",
    "S3BucketName": "test",
    "S3BucketPrefix": "test"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_elb_app_cookie_stickness_policy
    template = <<-EOS
Test _elb_app_cookie_stickiness_policy(app_cookie: [ { cookie: "test", policy: "test" } ])

    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": [
    {
      "CookieName": "test",
      "PolicyName": "test"
    }
  ]
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_elb_connection_draining_policy
    template = <<-EOS
Test _elb_connection_draining_policy(connection_draining: {})
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Enabled": "true",
    "Timeout": "60"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_elb_connection_settings
    template = <<-EOS
Test _elb_connection_settings({ })
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "IdleTimeout": "60"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_elb_health_check
    template = <<-EOS
Test _elb_health_check({ })
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "HealthyThreshold": "10",
    "Interval": "30",
    "Target": "HTTP:80/index.html",
    "Timeout": "5",
    "UnhealthyThreshold": "2"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_elb_cookie_stickiness_policy
    template = <<-EOS
Test _elb_cookie_stickiness_policy(cookie_stickiness: [ { expiration: 0, policy: "test" } ])
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": [
    {
      "CookieExpirationPeriod": "0",
      "PolicyName": "test"
    }
  ]
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_elb_listeners
    template = <<-EOS
Test _elb_listeners({})
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": [
    {
      "InstancePort": "80",
      "InstanceProtocol": "HTTP",
      "LoadBalancerPort": "80",
      "Protocol": "HTTP"
    }
  ]
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
Test _elb_listeners({ listeners: [ { protocol: "https", ssl: "test" } ] })
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": [
    {
      "InstancePort": "443",
      "InstanceProtocol": "HTTPS",
      "LoadBalancerPort": "443",
      "PolicyNames": [
        "ELBSecurityPolicy-2016-08"
      ],
      "Protocol": "HTTPS",
      "SSLCertificateId": "test"
    }
  ]
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
Test _elb_listeners({ listeners: [ { protocol: "https", ssl: "test", policy: "TLS-1-2-2017-01" } ] })
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": [
    {
      "InstancePort": "443",
      "InstanceProtocol": "HTTPS",
      "LoadBalancerPort": "443",
      "PolicyNames": [
        "ELBSecurityPolicy-TLS-1-2-2017-01"
      ],
      "Protocol": "HTTPS",
      "SSLCertificateId": "test"
    }
  ]
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_elb_policy_types
    template = <<-EOS
Test _elb_policy_types(policy: [ { name: "test", type: "test" } ])
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": [
    {
      "PolicyName": "test",
      "PolicyType": "test"
    }
  ]
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
