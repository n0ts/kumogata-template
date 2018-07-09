require 'abstract_unit'

class ElasticacheReplicationGroupTest < Minitest::Test
  def test_normal
    template = <<-EOS
_elasticache_replication_group "test", ref_security_groups: "test", ref_subnet: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestCacheReplicationGroup": {
    "Type": "AWS::ElastiCache::ReplicationGroup",
    "Properties": {
      "AutomaticFailoverEnabled": "true",
      "AutoMinorVersionUpgrade": "true",
      "CacheNodeType": "cache.t2.medium",
      "CacheParameterGroupName": "default.redis2.8",
      "CacheSubnetGroupName": {
        "Ref": "TestCacheSubnetGroup"
      },
      "Engine": "redis",
      "EngineVersion": "2.8.6",
      "NumCacheClusters": "2",
      "Port": "6379",
      "PreferredCacheClusterAZs": {
        "Fn::GetAZs": {
          "Ref": "AWS::Region"
        }
      },
      "PreferredMaintenanceWindow": "Thu:20:15-Thu:21:15",
      "ReplicationGroupDescription": "test cache replication group description",
      "SecurityGroupIds": [
        {
          "Ref": "TestSecurityGroup"
        }
      ],
      "SnapshotRetentionLimit": "10",
      "SnapshotWindow": "21:15-22:15",
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
