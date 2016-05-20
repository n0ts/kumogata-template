require 'abstract_unit'

class EventsTargetTest < Minitest::Test
  def test_normal
    template = <<-EOS
_events_rule "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestEventsRule": {
    "Type": "AWS::Events::Rule",
    "Properties": {
      "Name": {
        "Fn::Join": [
          "-",
          [
            {
              "Ref": "Service"
            },
            {
              "Ref": "Name"
            }
          ]
        ]
      },
      "State": "ENABLED"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
