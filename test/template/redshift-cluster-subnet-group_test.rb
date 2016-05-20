require 'abstract_unit'

class RedshiftClusterSubnetGroupTest < Minitest::Test
  def test_normal
    template = <<-EOS
_redshift_cluster_subnet_group "test", ref_subnets: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestRedshiftClusterSubnetGroup": {
    "Type": "AWS::Redshift::ClusterSubnetGroup",
    "Properties": {
      "Description": "test redshift cluster subnet group description",
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
