#
# EC2 VPC endpoint resource
# https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-vpcendpoint.html
#
require 'kumogata/template/helper'
require 'kumogata/template/iam'

name = _resource_name(args[:name], "vpc endpoint")
route_tables = _ref_array("route_tables", args, "route table")
region = _ref_string("region", args)
region = _region if region.empty?
service = args[:service] || "s3"
vpc = _ref_string("vpc", args, "vpc")

_(name) do
  Type "AWS::EC2::VPCEndpoint"
  Properties do
    PolicyDocument do
      Version "2012-10-17"
      Statement _iam_policy_document("policy_document", args)
    end
    RouteTableIds route_tables
    ServiceName _join([ "com.amazonaws", region, service ], ".")
    VpcId vpc
  end
end
