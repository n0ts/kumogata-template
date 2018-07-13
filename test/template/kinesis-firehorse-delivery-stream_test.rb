require 'abstract_unit'

class KinesisFirehoseDeliverySystemTest < Minitest::Test
  def test_normal
    template = <<-EOS
_kinesis_firehose_delivery_stream "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestKinesisFirehoseDeliveryStream": {
    "Type": "AWS::KinesisFirehose::DeliveryStream",
    "Properties": {
      "DeliveryStreamName": {
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
      "DeliveryStreamType": "DirectPut"
    }
  }
}
EOS
    assert_equal exp_template.chomp, act_template
  end

  # FIXME
  def test_kinesis_stream
    template = <<-EOS
_kinesis_firehose_delivery_stream "test",
                                  stream: "kinesis",
                                  type: "kinesis", kinesis: { ref_stream: "test", ref_role: "test" }
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestKinesisFirehoseDeliveryStream": {
    "Type": "AWS::KinesisFirehose::DeliveryStream",
    "Properties": {
      "DeliveryStreamName": "kinesis",
      "DeliveryStreamType": "KinesisStreamAsSource",
      "KinesisStreamSourceConfiguration": {
      }
    }
  }
}
EOS
    assert_equal exp_template.chomp, act_template
  end
end
