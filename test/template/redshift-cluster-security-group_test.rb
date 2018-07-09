require 'abstract_unit'

class RedshiftClusterSecurityGroupTest < Minitest::Test
  def test_normal
    template = <<-EOS
_redshift_cluster_security_group "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestRedshiftClusterSecurityGroup": {
    "Type": "AWS::Redshift::ClusterSecurityGroup",
    "Properties": {
      "Description": "test redshift cluster security group description",
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
