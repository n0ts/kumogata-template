require 'abstract_unit'

class RedshiftClusterParameterGroupTest < Minitest::Test
  def test_normal
    template = <<-EOS
parameters = [ { name: "enable_user_activity_logging", value: "true" } ]
_redshift_cluster_parameter_group "test", parameters: parameters
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
      ],
      "Tags": [
        {
          "Key": "Name",
          "Value": {
            "Fn::Join": [
              "-",
              [
                {
                  "Ref": "Service"
                },
                "test"
              ]
            ]
          }
        },
        {
          "Key": "Service",
          "Value": {
            "Ref": "Service"
          }
        },
        {
          "Key": "Version",
          "Value": {
            "Ref": "Version"
          }
        }
      ]
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
