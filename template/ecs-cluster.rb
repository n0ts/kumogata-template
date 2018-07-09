#
# ECS Cluster resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ecs-cluster.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "ecs cluster")
cluster = _name("cluster", args)

_(name) do
  Type "AWS::ECS::Cluster"
  Properties do
    ClusterName cluster
  end
end
