#
# ECS Service resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ecs-service.html
#
require 'kumogata/template/helper'
require 'kumogata/template/ecs'

name = _resource_name(args[:name], "ecs service")
cluster = _ref_string("cluster", args, "ecs cluster")
deployment = _ecs_deployment(args)
desired = _ref_string("desired_count", args, "ecs desired count")
load_balancers = _ecs_load_balancers(args)
placement = _ecs_placement_service(args)
role = args[:role] || ""
service_name = _real_name("service", args)
task = _ref_string("task", args, "ecs task definition")

_(name) do
  Type "AWS::ECS::Service"
  Properties do
    Cluster cluster
    DeploymentConfiguration deployment unless deployment.empty?
    DesiredCount desired
    LoadBalancers load_balancers unless load_balancers.empty?
    PlacementConstraints placement unless placement.empty?
    Role role unless role.empty?
    ServiceName service_name if service_name
    TaskDefinition task
  end
end
