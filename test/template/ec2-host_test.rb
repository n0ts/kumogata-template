require 'abstract_unit'

class Ec2HostTest < Minitest::Test
  def test_normal
    template = <<-EOS
_ec2_host "test", auto: "on", az: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestHost": {
    "Type": "AWS::EC2::Host",
    "Properties": {
      "AutoPlacement": "on",
      "AvailabilityZone": "test",
      "InstanceType": "c4.large"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end

