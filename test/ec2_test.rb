require 'abstract_unit'
require 'kumogata/template/ec2'

class Ec2Test < Minitest::Test
  def test_ec2_tags
    template = <<-EOS
Test _ec2_tags(name: "test")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": [
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
    },
    {
      "Key": "Domain",
      "Value": {
        "Ref": "Domain"
      }
    },
    {
      "Key": "Role",
      "Value": {
        "Ref": "Role"
      }
    }
  ]
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
Test _ec2_tags(name: "test", tags_append: { ref_test: "test" })
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": [
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
    },
    {
      "Key": "Domain",
      "Value": {
        "Ref": "Domain"
      }
    },
    {
      "Key": "Role",
      "Value": {
        "Ref": "Role"
      }
    },
    {
      "Key": "Test",
      "Value": {
        "Ref": "Test"
      }
    }
  ]
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_ec2_security_group_egresses
    template = <<-EOS
args = { egress: [ to: 80, group: "test" ] }
Test _ec2_security_group_egresses("egress", args)
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": [
    {
      "CidrIp": "0.0.0.0/0",
      "FromPort": "80",
      "GroupId": "test",
      "IpProtocol": "tcp",
      "ToPort": "80"
    }
  ]
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_ec2_security_group_eggress
    template = <<-EOS
Test _ec2_security_group_egress(to: 80, group: "test")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "CidrIp": "0.0.0.0/0",
    "FromPort": "80",
    "GroupId": "test",
    "IpProtocol": "tcp",
    "ToPort": "80"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_ec2_securiry_group_ingresses
    template = <<-EOS
args = { ingress: [ from: 80 ] }
Test _ec2_security_group_ingresses("ingress", args)
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": [
    {
      "CidrIp": "0.0.0.0/0",
      "FromPort": "80",
      "IpProtocol": "tcp",
      "ToPort": "80"
    }
  ]
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_ec2_security_group_ingress
    template = <<-EOS
Test _ec2_security_group_ingress(from: 80)
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "CidrIp": "0.0.0.0/0",
    "FromPort": "80",
    "IpProtocol": "tcp",
    "ToPort": "80"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_ec2_block_device
    template = <<-EOS
Test _ec2_block_device(ref_size: "test")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "DeviceName": "/dev/sda1",
    "Ebs": {
      "DeleteOnTermination": "true",
      "VolumeSize": {
        "Ref": "TestVolumeSize"
      },
      "VolumeType": "gp2"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_ec2_network_interface
    template = <<-EOS
Test _ec2_network_interface(ref_subnet_id: "test")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "AssociatePublicIpAddress": "true",
    "DeleteOnTermination": "true",
    "DeviceIndex": "0",
    "SubnetId": ""
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_ec2_image
    template = <<-EOS
Test _ec2_image("test", {})
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Fn::FindInMap": [
      "AWSRegionArch2AMIAmazonLinuxOfficial",
      {
        "Ref": "AWS::Region"
      },
      {
        "Fn::FindInMap": [
          "AWSInstanceType2Arch",
          "test",
          "Arch"
        ]
      }
    ]
  }
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
Test _ec2_image("test", { image_id: "test" })
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": "test"
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_ec2_port_range
    template = <<-EOS
Test _ec2_port_range({})
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "From": "0",
    "To": "65535"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
