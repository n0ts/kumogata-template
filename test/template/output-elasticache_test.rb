require 'abstract_unit'

class OutputElasticacheTest < Minitest::Test
  def test_normal
    template = <<-EOS
_output_elasticache "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestCacheCluster": {
    "Description": "description of TestCacheCluster",
    "Value": {
      "Ref": "TestCacheCluster"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
_output_elasticache "test", replication: true, engine: "redis"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestCacheReplicationGroup": {
    "Description": "description of TestCacheReplicationGroup",
    "Value": {
      "Ref": "TestCacheReplicationGroup"
    }
  },
  "TestCacheReplicationGroupPrimaryAddress": {
    "Description": "description of TestCacheReplicationGroupPrimaryAddress",
    "Value": {
      "Fn::GetAtt": [
        "TestCacheReplicationGroup",
        "PrimaryEndPoint.Address"
      ]
    }
  },
  "TestCacheReplicationGroupPrimaryPort": {
    "Description": "description of TestCacheReplicationGroupPrimaryPort",
    "Value": {
      "Fn::GetAtt": [
        "TestCacheReplicationGroup",
        "PrimaryEndPoint.Port"
      ]
    }
  },
  "TestCacheReplicationGroupReadAddresses": {
    "Description": "description of TestCacheReplicationGroupReadAddresses",
    "Value": {
      "Fn::GetAtt": [
        "TestCacheReplicationGroup",
        "ReadEndPoint.Addresses"
      ]
    }
  },
  "TestCacheReplicationGroupReadPorts": {
    "Description": "description of TestCacheReplicationGroupReadPorts",
    "Value": {
      "Fn::GetAtt": [
        "TestCacheReplicationGroup",
        "ReadEndPoint.Ports"
      ]
    }
  }
}
    EOS

    assert_equal exp_template.chomp, act_template
    template = <<-EOS
_output_elasticache "test", engine: "memcached"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestCacheCluster": {
    "Description": "description of TestCacheCluster",
    "Value": {
      "Ref": "TestCacheCluster"
    }
  },
  "TestCacheClusterAddress": {
    "Description": "description of TestCacheClusterAddress",
    "Value": {
      "Fn::GetAtt": [
        "TestCacheCluster",
        "ConfigurationEndpoint.Address"
      ]
    }
  },
  "TestCacheClusterPort": {
    "Description": "description of TestCacheClusterPort",
    "Value": {
      "Fn::GetAtt": [
        "TestCacheCluster",
        "ConfigurationEndpoint.Port"
      ]
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
