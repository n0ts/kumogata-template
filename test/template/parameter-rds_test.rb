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
  "TestDbClasses": {
    "Type": "String",
    "Default": "#{RDS_DEFAULT_INSTANCE_CLASS}",
    "Description": "test db instance classes",
    "AllowedValues": [
#{values.chomp}
    ]
  },
  "TestDbPort": {
    "Type": "Number",
    "Default": "test",
    "Description": "test db instance port"
  },
  "TestDbName": {
    "Type": "String",
    "Default": "test",
    "Description": "test db instance db name"
  },
  "TestDbMasterUserName": {
    "Type": "String",
    "Default": "test",
    "Description": "test db instance master user name",
    "MaxLength": "16",
    "MinLength": "2"
  },
  "TestDbMasterUserPassword": {
    "Type": "String",
    "Default": "test",
    "Description": "test db instance master user password",
    "MaxLength": "64",
    "MinLength": "8",
    "NoEcho": "true"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
