#
# ECS Task Definition resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ecs-taskdefinition.html
#
require 'kumogata/template/helper'
require 'kumogata/template/ecs'

name = _resource_name(args[:name], "ecs task definition")
volumes = _ecs_volumes(args)
family = args[:family] || ""
network = _valid_values(args[:network], %w( bridge host none ), "")
placement = _ecs_placement_definition(args)
role = _ref_attr_string("role", "Arn", args, "role")
definitions = _ecs_container_definitions(args)

_(name) do
  Type "AWS::ECS::TaskDefinition"
  Properties do
    Volumes volumes
    Family family unless family.empty?
    NetworkMode network unless network.empty?
    PlacementConstraints placement unless placement.empty?
    TaskRoleArn role unless role.empty?
    ContainerDefinitions definitions
  end
end
