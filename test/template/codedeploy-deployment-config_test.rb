require 'abstract_unit'

class CodedeployDeploymentConfigTest < Minitest::Test
  def test_normal
    template = <<-EOS
_codedeploy_deployment_config "test", deployment: "test",
                                      minimum: { type: "fleet_percent", value: "75" }
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestDeploymentConfig": {
    "Type": "AWS::CodeDeploy::DeploymentConfig",
    "Properties": {
      "DeploymentConfigName": "test",
      "MinimumHealthyHosts": {
        "Type": "FLEET_PERCENT",
        "Value": "75"
      }
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
