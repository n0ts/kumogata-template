require 'abstract_unit'
require 'kumogata/template/const'

class ParameterElasticaheTest < Minitest::Test
  def test_normal
    values = ''
    ELASTICACHE_NODE_TYPES.each_with_index do |v, i|
      values +=<<-EOS
      "#{v}"#{i == (ELASTICACHE_NODE_TYPES.size - 1) ? '': ','}
EOS
    end
    template = <<-EOS
_parameter_elasticache "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestCacheNodeTypes": {
    "Type": "String",
    "Default": "#{ELASTICACHE_DEFAULT_NODE_TYPE}",
    "Description": "test cache node types",
    "AllowedValues": [
#{values.chomp}
    ]
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
