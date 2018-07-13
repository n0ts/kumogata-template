require 'abstract_unit'

class ElasticacheCacheClusterTest < Minitest::Test
  def test_normal
    template = <<-EOS
_elasticache_cache_cluster "test", ref_security_groups: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestCacheCluster": {
    "Type": "AWS::ElastiCache::CacheCluster",
    "Properties": {
      "AutoMinorVersionUpgrade": "true",
      "CacheNodeType": "cache.t2.medium",
      "CacheParameterGroupName": "default.redis2.8",
      "CacheSubnetGroupName": "",
      "ClusterName": {
        "Fn::Join": [
          "-",
          [
            {
              "Ref": "Service"
            },
            "test"
          ]
        ]
      },
      "Engine": "redis",
      "EngineVersion": "2.8.6",
      "NumCacheNodes": "1",
      "Port": "6379",
      "PreferredMaintenanceWindow": "Thu:20:15-Thu:21:15",
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
      ],
      "VpcSecurityGroupIds": [
        {
          "Ref": "TestSecurityGroup"
        }
      ]
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
