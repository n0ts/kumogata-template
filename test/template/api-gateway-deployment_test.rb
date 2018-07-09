require 'abstract_unit'

class ApiGatewayDeploymentTest < Minitest::Test
  def test_normal
    template = <<-EOS
_api_gateway_deployment "test", ref_rest: "test", ref_stage: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestDeployment": {
    "Type": "AWS::ApiGateway::Deployment",
    "Properties": {
      "Description": "test deployment description",
      "RestApiId": {
        "Ref": "TestRestApi"
      },
      "StageName": {
        "Ref": "Test"
      }
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
