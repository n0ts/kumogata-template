#
# CodeDeploy DeploymentGroup resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-codedeploy-deploymentgroup.html
#
require 'kumogata/template/helper'
require 'kumogata/template/codedeploy'

name = _resource_name(args[:name], "deployment group")
alarm = _codedeploy_alarm(args)
application = _ref_string("application", args, "codedeploy application")
autoscalings = _ref_array("autoscalings", args, "autoscaling group")
deployment =
  if args.key? :deployment
    _codedeploy_deployment(args[:deployment])
  else
    ""
  end
deployment_config = args[:deplyoment_config] || ""
deployment_group = args[:deployment_group] || ""
ec2_tag = (args[:ec2_tag] || []).collect{|v| _codedeploy_tag_filters(v) }
on_premises = (args[:on_premises] || []).collect{|v| _codedeploy_tag_filters(v) }
service = _ref_string("service", args, "service role")

_(name) do
  Type "AWS::CodeDeploy::DeploymentGroup"
  Properties do
    AlarmConfiguration alarm unless alarm.empty?
    ApplicationName application
    AutoScalingGroups autoscalings unless autoscalings.empty?
    Deployment deployment unless deployment.empty?
    DeploymentConfigName deployment_config unless deployment_config.empty?
    DeploymentGroupName deployment_group unless deployment_group.empty?
    Ec2TagFilters  ec2_tag unless ec2_tag.empty?
    OnPremisesInstanceTagFilters on_premises unless on_premises.empty?
    ServiceRoleArn service
  end
end
