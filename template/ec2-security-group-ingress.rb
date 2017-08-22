#
# EC2 Security Group Ingress resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-security-group-ingress.html
#
require 'kumogata/template/helper'
require 'kumogata/template/ec2'

name = _resource_name(args[:name], "security group ingress")
ingress = _ec2_security_group_ingress_rule(args)
group_id = _ref_string("group_id", args, "security group")
ingress["GroupId"] = group_id unless group_id.empty?
group_name = _ref_string("group_name", args, "security group")
ingress["GroupName"] = group_name unless group_name.empty?
ingress["GroupName"] = _ref_name("name", args, "security group") if group_name.empty? and group_id.empty?

_(name) do
  Type "AWS::EC2::SecurityGroupIngress"
  Properties ingress
end
