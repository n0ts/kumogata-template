require 'abstract_unit'

class ApiGatewayBasePathMappingTest < Minitest::Test
  def test_normal
    template = <<-EOS
_api_gateway_base_path_mapping "test", ref_domain: "test", ref_rest: "test", path: ""
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestBasePathMapping": {
    "Type": "AWS::ApiGateway::BasePathMapping",
    "Properties": {
      "BasePath": "",
      "DomainName": {
        "Ref": "TestDomain"
      },
      "RestApiId": {
        "Ref": "TestRestApi"
      }
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
