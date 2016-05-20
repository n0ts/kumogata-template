require 'abstract_unit'

class Ec2SubnetRouteTableAssociationTest < Minitest::Test
  def test_normal
    template = <<-EOS
_ec2_subnet_route_table_association "test", route_table: "test", subnet: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestSubnetRouteTableAssociation": {
    "Type": "AWS::EC2::SubnetRouteTableAssociation",
    "Properties": {
      "RouteTableId": "test",
      "SubnetId": "test"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
