require 'abstract_unit'

class KinesisStreamTest < Minitest::Test
  def test_normal
    template = <<-EOS
_kinesis_stream "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestKinesisStream": {
    "Type": "AWS::Kinesis::Stream",
    "Properties": {
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
      "RetentionPeriodHours": "24",
      "ShardCount": "1",
      "Tags": [
        {
          "Key": "Name",
          "Value": {
            "Fn::Join": [
              "-",
              [
                {
                  "Ref": "Service"
                },
                "test"
              ]
            ]
          }
        },
        {
          "Key": "Service",
          "Value": {
            "Ref": "Service"
          }
        },
        {
          "Key": "Version",
          "Value": {
            "Ref": "Version"
          }
        }
      ]
    }
  }
}
EOS
    assert_equal exp_template.chomp, act_template
  end
end
