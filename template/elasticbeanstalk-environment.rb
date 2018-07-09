#
# Elasticbeanstalk Environment resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-beanstalk-environment.html
#
require 'kumogata/template/helper'
require 'kumogata/template/elasticbeanstalk'

name = _resource_name(args[:name], "elasticbeanstalk environment")
application = _ref_string("application", args, "elasticbeanstalk application")
cname = _ref_string("cname", args)
description = _ref_string_default("description", args, '', "#{args[:name]} elasticbeanstalk environment description")
environment = _ref_string("environment", args)
options =
  if args.key? :options
    _elasticbeanstalk_options(args[:options])
   else
    ""
  end
solution = _ref_string("solution", args)
template = _ref_string("template", args)
tier =
  if args.key? :tier
    _elasticbeanstalk_tier(args[:tier])
  else
    ""
  end
version = _ref_string("version", args, "elasticbeanstalk application version")
tags = _tags(args)

_(name) do
  Type "AWS::ElasticBeanstalk::Environment"
  Properties do
    ApplicationName application
    CNAMEPrefix cname unless cname.empty?
    Description description unless description.empty?
    EnvironmentName environment
    OptionSettings options unless options.empty?
    SolutionStackName solution
    Tags tags
    TemplateName template unless template.empty?
    Tier tier unless tier.empty?
    VersionLabel version unless version.empty?
  end
end
