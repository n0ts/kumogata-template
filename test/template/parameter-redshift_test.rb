require 'abstract_unit'
require 'kumogata/template/const'

class ParameterRdsInstanceTest < Minitest::Test
  def test_normal
    values = ''
    REDSHIFT_NODE_TYPES.each_with_index do |v, i|
      values +=<<-EOS
      "#{v}"#{i == (REDSHIFT_NODE_TYPES.size - 1) ? '': ','}
EOS
    end
    template = <<-EOS
_parameter_redshift "test", port: "test", user_name: "test", user_password: "test", db_name: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestRedshiftClusterNodeTypes": {
    "Type": "String",
    "Default": "#{REDSHIFT_DEFAULT_NODE_TYPE}",
    "Description": "test redshift cluster node types",
    "AllowedValues": [
#{values.chomp}
    ]
  },
  "TestRedshiftClusterPort": {
    "Type": "Number",
    "Default": "test",
    "Description": "test redshift cluster port"
  },
  "TestRedshiftClusterDbName": {
    "Type": "String",
    "Default": "test",
    "Description": "test redshift cluster db name"
  },
  "TestRedshiftClusterMasterUserName": {
    "Type": "String",
    "Default": "test",
    "Description": "test redshift cluster master user name",
    "MaxLength": "16",
    "MinLength": "2"
  },
  "TestRedshiftClusterMasterUserPassword": {
    "Type": "String",
    "Default": "test",
    "Description": "test redshift cluster master user password",
    "MaxLength": "64",
    "MinLength": "8",
    "NoEcho": "true"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
