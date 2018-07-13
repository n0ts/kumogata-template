require 'abstract_unit'

class RdsOptionGroupTest < Minitest::Test
  def test_normal
    template = <<-EOS
_rds_option_group "test", configurations: [ { name: "MEMCACHED" } ]
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestOptionGroup": {
    "Type": "AWS::RDS::OptionGroup",
    "Properties": {
      "EngineName": "mysql",
      "MajorEngineVersion": "5.7",
      "OptionGroupDescription": "test option group description",
      "OptionConfigurations": [
        {
          "OptionName": "MEMCACHED"
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
