#
# ElasticBeanstalk Application resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-beanstalk.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "elasticbeanstalk application")
application = _ref_string("application", args)
application = args[:name] if application.empty?
description = _ref_string_default("description", args, '', "#{args[:name]} elasticbeanstalk application description")

_(name) do
  Type "AWS::ElasticBeanstalk::Application"
  Properties do
    ApplicationName application
    Description description unless description.empty?
  end
end
