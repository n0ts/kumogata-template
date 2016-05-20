#
# ECS TaskDefinition resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ecs-taskdefinition.html
#
require 'kumogata/template/helper'
require 'kumogata/template/ecs'

name = _resource_name(args[:name], "ecs task definition")
definitions = _ecs_container_definitions(args)
volumes = _ecs_volumes(args)

_(name) do
  Type "AWS::ECS::TaskDefinition"
  Properties do
    ContainerDefinitions definitions
    Volumes volumes
  end
end
