#
# Codedeploy Application resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-codedeploy-application.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "codedeploy application")
application = _name("application", args)

_(name) do
  Type "AWS::CodeDeploy::Application"
  Properties do
    ApplicationName application
  end
end
