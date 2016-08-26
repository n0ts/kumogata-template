require 'abstract_unit'

class CertificateTest < Minitest::Test
  def test_normal
    template = <<-EOS
_certificate "test", domain: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestCertificate": {
    "Type": "AWS::CertificateManager::Certificate",
    "Properties": {
      "DomainName": "test",
      "DomainValidationOptions": [
        {
          "DomainName": "test",
          "ValidationDomain": "test"
        }
      ]
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
