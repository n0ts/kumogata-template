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
end
