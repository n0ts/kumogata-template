#
# EC2 Security Group Egress resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-security-group-egress.html
#
require 'kumogata/template/helper'
require 'kumogata/template/ec2'

name = _resource_name(args[:name], "security group egress")
egress = _ec2_security_group_egress_rule(args)
egress["GroupId"] = _ref_string("group", args, "security group")

_(name) do
  Type "AWS::EC2::SecurityGroupEgress"
  Properties egress
end
