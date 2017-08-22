require 'abstract_unit'

class Ec2PlacementGroupTest < Minitest::Test
  def test_normal
    template = <<-EOS
_ec2_placement_group "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestPlacementGroup": {
    "Type": "AWS::EC2::PlacementGroup",
    "Properties": {
      "Strategy": "cluster"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
