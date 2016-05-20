require 'abstract_unit'

class Ec2VpcGatewayAttachmentTest < Minitest::Test
  def test_normal
    template = <<-EOS
_ec2_vpc_gateway_attachment "test", vpc: "test", internet_gateway: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestVpcGatewayAttachment": {
    "Type": "AWS::EC2::VPCGatewayAttachment",
    "Properties": {
      "InternetGatewayId": "test",
      "VpcId": "test"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end

