require 'abstract_unit'

class ApiGatewayClientCertificateTest < Minitest::Test
  def test_normal
    template = <<-EOS
_api_gateway_client_certificate "test", description: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestClientCertificate": {
    "Type": "AWS::ApiGateway::ClientCertificate",
    "Properties": {
      "Description": "test"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
