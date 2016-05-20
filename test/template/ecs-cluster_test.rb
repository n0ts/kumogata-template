require 'abstract_unit'

class EcsClusterTest < Minitest::Test
  def test_normal
    template = <<-EOS
_ecs_cluster "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestEcsCluster": {
    "Type": "AWS::ECS::Cluster"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
