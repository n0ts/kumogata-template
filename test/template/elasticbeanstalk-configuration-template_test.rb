require 'abstract_unit'

class ElasticbeanstalkConfgiurationTemplateTest < Minitest::Test
  def test_normal
    template = <<-EOS
_elasticbeanstalk_configuration_template "test", ref_application: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestElasticbeanstalkConfigurationTemplate": {
    "Type": "AWS::ElasticBeanstalk::ConfigurationTemplate",
    "Properties": {
      "ApplicationName": {
        "Ref": "TestElasticbeanstalkApplication"
      },
      "Description": "test elasticbeanstalk configuration template description"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
