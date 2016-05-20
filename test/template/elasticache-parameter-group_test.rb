require 'abstract_unit'

class ElasticacheParameterGroupTest < Minitest::Test
  def test_normal
    template = <<-EOS
_elasticache_parameter_group "test", properties: { "timeout": 0 }
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestCacheParameterGroup": {
    "Type": "AWS::ElastiCache::ParameterGroup",
    "Properties": {
      "CacheParameterGroupFamily": "redis2.8",
      "Description": "test cache parameter group description",
      "Properties": {
        "timeout": 0
      }
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
