#
# Elasticbeanstalk ConfigurationTemplate resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-beanstalk-configurationtemplate.html
#
require 'kumogata/template/helper'
require 'kumogata/template/elasticbeanstalk'

name = _resource_name(args[:name], "elasticbeanstalk configuration template")
application = _ref_string("application", args, "elasticbeanstalk application")
description = args[:description] || ""
option = _elasticbeanstalk_option(args[:option] || [])
environment = args[:environment] || ""
solution = args[:solution] || ""
configuration =
  if args.key? :configuration
    _elasticbeanstalk_configuration(args[:configuration])
  else
    ""
  end

_(name) do
  Type "AWS::ElasticBeanstalk::ConfigurationTemplate"
  Properties do
    ApplicationName application
    Description description unless description.empty?
    EnvironmentId environment unless environment.empty?
    OptionSettings option unless option.empty?
    SolutionStackName solution unless solution.empty?
    SourceConfiguration configuration unless configuration.empty?
  end
end
