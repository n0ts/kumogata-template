require 'abstract_unit'

class EcsServiceTest < Minitest::Test
  def test_normal
    template = <<-EOS
_ecs_service "test", ref_cluster: "test", ref_desired_count: "test", ref_task: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestEcsService": {
    "Type": "AWS::ECS::Service",
    "Properties": {
      "Cluster": {
        "Ref": "TestEcsCluster"
      },
      "DesiredCount": {
        "Ref": "TestEcsDesiredCount"
      },
      "ServiceName": {
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
      "TaskDefinition": {
        "Ref": "TestEcsTaskDefinition"
      }
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
