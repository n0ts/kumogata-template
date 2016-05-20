require 'abstract_unit'

class OutputEmrTest < Minitest::Test
  def test_normal
    template = <<-EOS
_output_emr "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestEmrCluster": {
    "Description": "description of TestEmrCluster",
    "Value": {
      "Ref": "TestEmrCluster"
    }
  },
  "TestEmrClusterMasterPublicDns": {
    "Description": "description of TestEmrClusterMasterPublicDns",
    "Value": {
      "Fn::GetAtt": [
        "TestEmrCluster",
        "MasterPublicDNS"
      ]
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
