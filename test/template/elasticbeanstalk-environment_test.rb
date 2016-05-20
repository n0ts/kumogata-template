require 'abstract_unit'

class ElasticbeanstalkEnvironmentTest < Minitest::Test
  def test_normal
    template = <<-EOS
_elasticbeanstalk_environment "test", ref_application: "test", description: "test", environment: "test", solution: "test", template: "test", version: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestElasticbeanstalkEnvironment": {
    "Type": "AWS::ElasticBeanstalk::Environment",
    "Properties": {
      "ApplicationName": {
        "Ref": "TestElasticbeanstalkApplication"
      },
      "Description": "test",
      "EnvironmentName": "test",
      "SolutionStackName": "test",
      "Tags": [
        {
          "Key": "Name",
          "Value": {
            "Fn::Join": [
              "-",
              [
                {
                  "Ref": "Service"
                },
                "test"
              ]
            ]
          }
        },
        {
          "Key": "Service",
          "Value": {
            "Ref": "Service"
          }
        },
        {
          "Key": "Version",
          "Value": {
            "Ref": "Version"
          }
        }
      ],
      "TemplateName": "test",
      "VersionLabel": "test"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
