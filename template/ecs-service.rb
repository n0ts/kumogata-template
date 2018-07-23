#
# ECS Service resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ecs-service.html
#
require 'kumogata/template/helper'
require 'kumogata/template/ecs'

name = _resource_name(args[:name], "ecs service")
cluster = _ref_string("cluster", args, "ecs cluster", "arn")
deployment = _ecs_deployment(args)
desired = _ref_string("desired", args, "ecs desired count")
health_check = args[:health_check] || ''
launch_type = _valid_values(args[:launch_type], %w( ec2 fargate ), 'ec2')
load_balancers = _ecs_load_balancers(args)
network = _ecs_network(args)
placement_c = _ecs_placement_definition(args, 'placement_c')
placement_s = _ecs_placement_strategies(args, 'placement_s')
platform = args[:platform] || ''
role = _ref_string_default("role", args, "role")
service = _name("service", args)
task = _ref_string("task", args, "ecs task definition")
depends = _depends([ { ref_lb: 'load balancer' } ], args)

_(name) do
  Type "AWS::ECS::Service"
  Properties do
    Cluster cluster
    DeploymentConfiguration deployment unless deployment.empty?
    DesiredCount desired
    HealthCheckGracePeriodSeconds health_check unless health_check.empty?
    LaunchType launch_type.upcase
    LoadBalancers load_balancers unless load_balancers.empty?
    NetworkConfiguration network unless network.empty?
    PlacementConstraints placement_c unless placement_c.empty?
    PlacementStrategies placement_s unless placement_s.empty?
    PlatformVersion platform unless platform.empty?
    Role role unless role.empty?
    ServiceName service
    TaskDefinition task
  end
  DependsOn depends unless depends.empty?
end
