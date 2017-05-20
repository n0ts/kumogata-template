require 'abstract_unit'
require 'kumogata/template/elasticbeanstalk'

class ElasticbeantalkTest < Minitest::Test
  def test_elasticbeanstalk_options
    template = <<-EOS
Test _elasticbeanstalk_options([ name: "test", option: "test", value: "test" ])
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": [
    {
      "Namespace": "test",
      "OptionName": "test",
      "Value": "test"
    }
  ]
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_elasticbeanstalk_configuration
    template = <<-EOS
Test _elasticbeanstalk_configuration(application: "test", template: "test")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "ApplicationName": "test",
    "TemplateName": "test"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_elasticbeanstalk_tier
    template = <<-EOS
Test _elasticbeanstalk_tier("test")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Name": "WebServer",
    "Type": "Standard",
    "Version": "1.0"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
