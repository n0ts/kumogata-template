require 'abstract_unit'
require 'kumogata/template/events'

class EventsTest < Minitest::Test
  def test_events_target
    template = <<-EOS
Test _events_targets({ targets: [ { arn: "test", id: "test" } ] })
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": [
    {
      "Arn": "test",
      "Id": "test"
    }
  ]
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_events_target_scheduled_ecs_task
    template = <<-EOS
Test _events_targets({
  schedule: "03 10 * * ? *",
  targets: [
    {
      id: "test-id",
      import_arn: "test",
      ref_role: "test",
      ecs_parameters: {
        task_count: 1,
        ref_task_definition: "test-task"
      }
    }
  ]
})
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": [
    {
      "Arn": {
        "Fn::ImportValue": {
          "Fn::Sub": "test"
        }
      },
      "Id": "test-id",
      "RoleArn": {
        "Fn::GetAtt": [
          "TestRole",
          "Arn"
        ]
      },
      "EcsParameters": {
        "TaskCount": "1",
        "TaskDefinitionArn": {
          "Ref": "TestTaskEcsTaskDefinition"
        }
      }
    }
  ]
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
