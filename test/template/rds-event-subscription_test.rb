require 'abstract_unit'

class RDSEventSubscriptionTest < Minitest::Test
  def test_normal
    template = <<-EOS
_rds_event_subscription "test", ref_sources: "test", ref_sns: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestEventSubscription": {
    "Type": "AWS::RDS::EventSubscription",
    "Properties": {
      "Enabled": "true",
      "EventCategories": [
        "availability",
        "backup",
        "configuration change",
        "creation",
        "deletion",
        "failover",
        "failure",
        "low storage",
        "maintenance",
        "notification",
        "read replica",
        "recovery",
        "restoration"
      ],
      "SnsTopicArn": {
        "Fn::GetAtt\": [
          "TestRole",
          "Arn"
        ]
      },
      "SourceIds": [
        {
          "Ref": "TestDbInstance"
        }
      ],
      "SourceType": "db-instance"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
