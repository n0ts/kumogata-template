require 'abstract_unit'

class RdsDbParameterGroupTest < Minitest::Test
  def test_normal
    template = <<-EOS
_rds_db_parameter_group "test", engine: 'mysql', parameters: { test: "test" }
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestDbParameterGroup": {
    "Type": "AWS::RDS::DBParameterGroup",
    "Properties": {
      "Description": "test db parameter group description",
      "Family": "mysql5.7",
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
