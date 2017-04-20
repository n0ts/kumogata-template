require 'abstract_unit'
require 'kumogata/template/elasticache'

class ElastiCacheTest < Minitest::Test
  def test_elasticache_to_engine
    template = <<-EOS
Test _elasticache_to_engine({})
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": "redis"
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_elasticache_to_node
    template = <<-EOS
Test _elasticache_to_node({})
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": "cache.t2.medium"
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
Test _elasticache_to_node(node: "r3.8xlarge")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": "cache.r3.8xlarge"
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_elasticache_to_parameter
    template = <<-EOS
Test _elasticache_to_parameter({})
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": "default.redis2.8"
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end

