#
# ECS Clusteer resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ecs-cluster.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "ecs cluster")

_(name) do
  Type "AWS::ECS::Cluster"
end
