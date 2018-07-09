require 'abstract_unit'

class ElasticbeanstalkTest < Minitest::Test
  def test_normal
    template = <<-EOS
_elasticbeanstalk_configuration_template "test", application: "test", solution: "test", options: [ { name: "test", option: "test", value: "test" } ], configuration: { application: "test", template: "test" }
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestElasticbeanstalkConfigurationTemplate": {
    "Type": "AWS::ElasticBeanstalk::ConfigurationTemplate",
    "Properties": {
      "ApplicationName": "test",
      "Description": "test elasticbeanstalk configuration template description",
      "OptionSettings": [
        {
          "Namespace": "test",
          "OptionName": "test",
          "Value": "test"
        }
      ],
      "SolutionStackName": "test",
      "SourceConfiguration": {
        "ApplicationName": "test",
        "TemplateName": "test"
      }
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
