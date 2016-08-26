require 'abstract_unit'

class Ec2LowLogTest < Minitest::Test
  def test_normal
    template = <<-EOS
_ec2_flow_log "test", ref_id: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestFlowLog": {
    "Type": "AWS::EC2::FlowLog",
    "Properties": {
      "LogGroupName": "test",
      "ResourceId": {
        "Ref": "TestVpc"
      },
      "ResourceType": "VPC",
      "TrafficType": "ALL"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
