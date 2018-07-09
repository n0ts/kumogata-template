require 'abstract_unit'

class Ec2VpcEndpointTest < Minitest::Test
  def test_normal
    template = <<-EOS
_ec2_vpc_endpoint "test", ref_route_tables: %w( test ), ref_vpc: "test",
                          policy_document: [ { service: "s3", principal: "*" } ]
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestVpcEndpoint": {
    "Type": "AWS::EC2::VPCEndpoint",
    "Properties": {
      "PolicyDocument": {
        "Version": "2012-10-17",
        "Statement": [
          {
            "Effect": "Allow",
            "Action": [
              "s3:*"
            ],
            "Resource": [
              "*"
            ],
            "Principal": "*"
          }
        ]
      },
      "RouteTableIds": [
        {
          "Ref": "TestRouteTable"
        }
      ],
      "ServiceName": {
        "Fn::Join": [
          ".",
          [
            "com.amazonaws",
            {
              "Ref": "AWS::Region"
            },
            "s3"
          ]
        ]
      },
      "VpcId": {
        "Ref": "TestVpc"
      }
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
