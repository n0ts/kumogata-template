require 'abstract_unit'

class ElasitcacheSubnetGroupTest < Minitest::Test
  def test_normal
    template = <<-EOS
_elasticache_subnet_group "test", ref_subnets: [ "test" ]
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestCacheSubnetGroup": {
    "Type": "AWS::ElastiCache::SubnetGroup",
    "Properties": {
      "Description": "test cache subnet group description",
      "SubnetIds": [
        {
          "Ref": "TestSubnet"
        }
      ]
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
