require 'abstract_unit'

class RedshiftClusterParameterGroupTest < Minitest::Test
  def test_normal
    template = <<-EOS
_redshift_cluster_parameter_group "test", parameters: [ ParameterName: "enable_user_activity_logging", ParameterValue: "true"]
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestRedshiftClusterParameterGroup": {
    "Type": "AWS::Redshift::ClusterParameterGroup",
    "Properties": {
      "Description": "test redshift cluster parameter group description",
      "ParameterGroupFamily": "redshift-1.0",
      "Parameters": [
        {
          "ParameterName": "enable_user_activity_logging",
          "ParameterValue": "true"
        }
      ]
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
