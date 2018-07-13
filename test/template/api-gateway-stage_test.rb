require 'abstract_unit'

class ApiGatewayStageTest < Minitest::Test
  def test_normal
    template = <<-EOS
_api_gateway_stage "test", ref_deployment: "test", ref_rest: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestStage": {
    "Type": "AWS::ApiGateway::Stage",
    "Properties": {
      "CacheClusterEnabled": "false",
      "DeploymentId": {
        "Ref": "TestDeployment"
      },
      "Description": "test stage description",
      "RestApiId": {
        "Ref": "TestRestApi"
      },
      "StageName": {
        "Fn::Join": [
          "_",
          [
            {
              "Ref": "Service"
            },
            "test"
          ]
        ]
      }
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
