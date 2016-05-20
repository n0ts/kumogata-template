require 'abstract_unit'

class RdsDbSubnetGroupTest < Minitest::Test
  def test_normal
    template = <<-EOS
_rds_db_subnet_group "test", ref_subnets: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestDbSubnetGroup": {
    "Type": "AWS::RDS::DBSubnetGroup",
    "Properties": {
      "DBSubnetGroupDescription": "test db subnet group description",
      "SubnetIds": [
        {
          "Ref": "TestSubnet"
        }
      ],
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
