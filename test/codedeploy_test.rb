require 'abstract_unit'
require 'kumogata/template/codedeploy'

class CodedeployTest < Minitest::Test
  def test_codedeploy_minimum
    template = <<-EOS
Test _codedeploy_minimum(type: "fleet_percent", value: "75")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Type": "FLEET_PERCENT",
    "Value": "75"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_codedeploy_alarm
    template = <<-EOS
Test _codedeploy_alarm(alarm: { alarms: [ "test" ] })
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Alarms": [
      {
        "Name": "test"
      }
    ],
    "Enabled": "true",
    "IgnorePollAlarmFailure": "false"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_codedeploy_deployment
    template = <<-EOS
Test _codedeploy_deployment(description: "test", revision: { s3: { bucket: "test", key: "test", version: "test" } })
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Description": "test",
    "IgnoreApplicationStopFailures": "true",
    "Revision": {
      "RevisionType": "S3",
      "S3Location": {
        "Bucket": "test",
        "Key": "test",
        "BundleType": "Zip",
        "Version": "test"
      }
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_codedeploy_revision
    template = <<-EOS
Test _codedeploy_revision(s3: { bucket: "test", key: "test", version: "test" })
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "RevisionType": "S3",
    "S3Location": {
      "Bucket": "test",
      "Key": "test",
      "BundleType": "Zip",
      "Version": "test"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_codedeploy_github
    template = <<-EOS
Test _codedeploy_github(commit: "test", repository: "test")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "CommitId": "test",
    "Repository": "test"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_codedeploy_s3
    template = <<-EOS
Test _codedeploy_s3(bucket: "test", key: "test", version: "test")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Bucket": "test",
    "Key": "test",
    "BundleType": "Zip",
    "Version": "test"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_codedeploy_tag_filters
    template = <<-EOS
Test _codedeploy_tag_filters(key: "test", value: "test")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Key": "test",
    "Type": "KEY_AND_VALUE",
    "Value": "test"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
