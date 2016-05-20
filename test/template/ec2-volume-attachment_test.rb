require 'abstract_unit'

class Ec2VolumeAttachmentTest < Minitest::Test
  def test_normal
    template = <<-EOS
_ec2_volume_attachment "test", instance: "test", volume: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestVolumeAttachment": {
    "Type": "AWS::EC2::VolumeAttachment",
    "Properties": {
      "Device": "/dev/sdb",
      "InstanceId": "test",
      "VolumeId": "test"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end

