require 'abstract_unit'

class Ec2VolumeTest < Minitest::Test
  def test_normal
    template = <<-EOS
_ec2_volume "test", az: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestVolume": {
    "Type": "AWS::EC2::Volume",
    "Properties": {
      "AutoEnableIO": "false",
      "AvailabilityZone": "test",
      "Size": "10",
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
      ],
      "VolumeType": "gp2"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
