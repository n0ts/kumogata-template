require 'abstract_unit'

class RdsDbClusterParameterGroupTest < Minitest::Test
  def test_normal
    template = <<-EOS
_rds_db_cluster_parameter_group "test", engine: 'aurora', parameters: { test: "test" }
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestDbClusterParameterGroup": {
    "Type": "AWS::RDS::DBClusterParameterGroup",
    "Properties": {
      "Description": "test db cluster parameter group description",
      "Family": "aurora5.6",
      "Parameters": {
        "test": "test"
      },
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
