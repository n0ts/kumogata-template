#
# CodeDeploy DeploymentConfig resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-codedeploy-deploymentconfig.html
#
require 'kumogata/template/helper'
require 'kumogata/template/codedeploy'

name = _resource_name(args[:name], "deployment config")
deployment = _name("deployment", args)
minimum =
  if args.key? :minimum
    _codedeploy_minimum(args[:minimum])
  else
    ""
  end

_(name) do
  Type "AWS::CodeDeploy::DeploymentConfig"
  Properties do
    DeploymentConfigName deployment
    MinimumHealthyHosts minimum unless minimum.empty?
  end
end
