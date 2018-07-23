require 'abstract_unit'

class ApiGatewayDomainNameTest < Minitest::Test
  def test_normal
    template = <<-EOS
_api_gateway_domain_name "test", ref_certificate: "test", ref_domain: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestDomainName": {
    "Type": "AWS::ApiGateway::DomainName",
    "Properties": {
      "CertificateArn": {
        "Ref": "TestCertificate"
      },
      "DomainName": {
        "Ref": "TestDomain"
      }
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
