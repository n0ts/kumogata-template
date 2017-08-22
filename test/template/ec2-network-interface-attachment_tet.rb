require 'abstract_unit'

class Ec2NetworkInterfaceAttachmentTest < Minitest::Test
  def test_normal
    template = <<-EOS
_ec2_network_interface_attachment "test", ref_instance: "test", ref_network: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestNetworkInterfaceAttachment": {
    "Type": "AWS::EC2::NetworkInterfaceAttachment",
    "Properties": {
      "DeleteOnTermination": "true",
      "DeviceIndex": "0",
      "InstanceId": {
        "Ref": "TestInstance"
      },
      "NetworkInterfaceId": {
        "Ref": "TestNetworkInterface"
      }
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
