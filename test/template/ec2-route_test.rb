require 'abstract_unit'

class Ec2RouteTest < Minitest::Test
  def test_normal
    template = <<-EOS
_ec2_route "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestRoute": {
    "Type": "AWS::EC2::Route",
    "Properties": {
      "DestinationCidrBlock": "0.0.0.0/0"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
