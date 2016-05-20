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
_parameter_redshift "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestRedshiftClusterNodeTypes": {
    "Type": "String",
    "Default": "#{REDSHIFT_DEFAULT_NODE_TYPE}",
    "AllowedValues": [
#{values.chomp}
    ],
    "Description": "test redshift cluster node types"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
