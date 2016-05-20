#
# ElasticBeanstalk Application resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-beanstalk.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "elasticbeanstalk application")
application = _ref_name("application", args)
description = args[:description] || ""

_(name) do
  Type "AWS::ElasticBeanstalk::Application"
  Properties do
    ApplicationName application
    Destination description unless description.empty?
  end
end
