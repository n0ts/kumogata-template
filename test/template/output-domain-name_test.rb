require 'abstract_unit'

class OutputDomainNameTest < Minitest::Test
  def test_normal
    template = <<-EOS
_output_domain_name "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestDomainNameDomain": {
    "Description": "description of TestDomainNameDomain",
    "Value": {
      "Ref": "TestDomainName"
    }
  },
  "TestDomainNameDistribution": {
    "Description": "description of TestDomainNameDistribution",
    "Value": {
      "Fn::GetAtt": [
        "TestDomainName",
        "DistributionDomainName"
      ]
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
