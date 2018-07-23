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
      "Description": "test events rule description",
      "Name": {
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
      "ScheduleExpression": "rate(5 minute)",
      "State": "ENABLED"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

   def test_normal_with_empty_pattern
     template = <<-EOS
_events_rule "test", pattern: ""
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestEventsRule": {
    "Type": "AWS::Events::Rule",
    "Properties": {
      "Description": "test events rule description",
      "Name": {
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
      "ScheduleExpression": "rate(5 minute)",
      "State": "ENABLED"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_normal_with_dynamodb_pattern
    template = <<-EOS
_events_rule "test", pattern: {
  "source": [
    "aws.dynamodb"
  ],
  "detail": {
    "userAgent": [
      "application-autoscaling.amazonaws.com"
    ],
    "eventName": [
      "UpdateTable"
    ]
  }
}
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestEventsRule": {
    "Type": "AWS::Events::Rule",
    "Properties": {
      "Description": "test events rule description",
      "EventPattern": {
        "source": [
          "aws.dynamodb"
        ],
        "detail": {
          "userAgent": [
            "application-autoscaling.amazonaws.com"
          ],
          "eventName": [
            "UpdateTable"
          ]
        }
      },
      "Name": {
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
      "State": "ENABLED"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
