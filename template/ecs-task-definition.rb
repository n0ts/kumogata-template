#
# ECS Task Definition resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ecs-taskdefinition.html
#
require 'kumogata/template/helper'
require 'kumogata/template/ecs'

name = _resource_name(args[:name], "ecs task definition")
definitions = _ecs_container_definitions(args)
family = args[:family] || ""
network = _valid_values(args[:network], %w( bridge host none ), "")
role = _ref_attr_string("role", "Arn", args, "role")
volumes = _ecs_volumes(args)

_(name) do
  Type "AWS::ECS::TaskDefinition"
  Properties do
    ContainerDefinitions definitions
    Family family unless family.empty?
    NetworkMode network unless network.empty?
    TaskRoleArn role unless role.empty?
    Volumes volumes
  end
end
