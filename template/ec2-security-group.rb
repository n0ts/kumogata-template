#
# EC2 Security Group resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-security-group.html
#
require 'kumogata/template/helper'
require 'kumogata/template/ec2'

name = _resource_name(args[:name], "security group")
group_name = _name("group", args)
description = _ref_string_default('description', args, '', "#{args[:name]} security group description")
egress = _ec2_security_group_egress_rules("egress", args)
ingress = _ec2_security_group_ingress_rules("ingress", args)
tags = _tags(args)
vpc = _ref_string("vpc", args, "vpc")

_(name) do
  Type "AWS::EC2::SecurityGroup"
  Properties do
    GroupName group_name if group_name
    GroupDescription description
    SecurityGroupEgress egress unless egress.empty?
    SecurityGroupIngress ingress unless ingress.empty?
    Tags tags
    VpcId vpc unless vpc.empty?
  end
end
