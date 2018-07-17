require 'abstract_unit'
require 'kumogata/template/const'

class ParameterRdsTest < Minitest::Test
  def test_normal
    values = ''
    RDS_INSTANCE_CLASSES.each_with_index do |v, i|
      values +=<<-EOS
      "#{v}"#{i == (RDS_INSTANCE_CLASSES.size - 1) ? '': ','}
EOS
    end
    template = <<-EOS
_parameter_rds "test", port: "test", user_name: "test", user_password: "test", db_name: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestDbInstanceClass": {
    "Type": "String",
    "Default": "#{RDS_DEFAULT_INSTANCE_CLASS}",
    "Description": "test db instance db instance classes",
    "AllowedValues": [
#{values.chomp}
    ],
    "NoEcho": "false"
  },
  "TestDbPort": {
    "Type": "Number",
    "Default": "test",
    "Description": "test db instance db port",
    "NoEcho": "false"
  },
  "TestDbName": {
    "Type": "String",
    "Default": "test",
    "Description": "test db instance db name",
    "NoEcho": "false"
  },
  "TestDbMasterUserName": {
    "Type": "String",
    "Default": "test",
    "Description": "test db instance db master user name",
    "MaxLength": "16",
    "MinLength": "2",
    "NoEcho": "false"
  },
  "TestDbMasterUserPassword": {
    "Type": "String",
    "Default": "test",
    "Description": "test db instance db master user password",
    "MaxLength": "64",
    "MinLength": "8",
    "NoEcho": "true"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
