require 'abstract_unit'

class ApiGatewayResourceTest < Minitest::Test
  def test_normal
    template = <<-EOS
_api_gateway_resource "test", ref_rest: "test", ref_path: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestResource": {
    "Type": "AWS::ApiGateway::Resource",
    "Properties": {
      "ParentId": {
        "Fn::GetAtt": [
          "TestRestApi",
          "RootResourceId"
        ]
      },
      "PathPart": {
        "Ref": "Test"
      },
      "RestApiId": {
        "Ref": "TestRestApi"
      }
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
_api_gateway_resource "test", ref_rest: "test", path: "/test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestResource": {
    "Type": "AWS::ApiGateway::Resource",
    "Properties": {
      "ParentId": {
        "Fn::GetAtt": [
          "TestRestApi",
          "RootResourceId"
        ]
      },
      "PathPart": "test",
      "RestApiId": {
        "Ref": "TestRestApi"
      }
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
_api_gateway_resource "test", ref_rest: "test", proxy: true
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestResource": {
    "Type": "AWS::ApiGateway::Resource",
    "Properties": {
      "ParentId": {
        "Fn::GetAtt": [
          "TestRestApi",
          "RootResourceId"
        ]
      },
      "PathPart": "{proxy+}",
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
