require 'abstract_unit'

class OutputRedshiftTest < Minitest::Test
  def test_normal
    template = <<-EOS
_output_redshift "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestRedshiftCluster": {
    "Description": "description of TestRedshiftCluster",
    "Value": {
      "Ref": "TestRedshiftCluster"
    }
  },
  "TestRedshiftClusterAddress": {
    "Description": "description of TestRedshiftClusterAddress",
    "Value": {
      "Fn::GetAtt": [
        "TestRedshiftCluster",
        "Endpoint.Address"
      ]
    }
  },
  "TestRedshiftClusterPort": {
    "Description": "description of TestRedshiftClusterPort",
    "Value": {
      "Fn::GetAtt": [
        "TestRedshiftCluster",
        "Endpoint.Port"
      ]
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
