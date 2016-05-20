#
# Elasticbeanstalk Environment resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-beanstalk-environment.html
#
require 'kumogata/template/helper'
require 'kumogata/template/elasticbeanstalk'

name = _resource_name(args[:name], "elasticbeanstalk environment")
application = _ref_string("application", args, "elasticbeanstalk application")
cname = args[:cname] || ""
description = args[:description] || ""
environment = _ref_name("environment", args)
option =
  if args.key? :option
    _elasticbeanstalk_option(args[:option])
   else
    ""
  end
solution = args[:solution] || ""
template = args[:template] || ""
tier =
  if args.key? :tier
    _elasticbeanstalk_tier(args[:tier])
  else
    ""
  end
version = args[:version] || ""
tags = _tags(args)

_(name) do
  Type "AWS::ElasticBeanstalk::Environment"
  Properties do
    ApplicationName application
    CNAMEPrefix cname unless cname.empty?
    Description description unless description.empty?
    EnvironmentName environment
    OptionSettings option unless option.empty?
    SolutionStackName solution
    Tags tags
    TemplateName template unless template.empty?
    Tier tier unless tier.empty?
    VersionLabel version unless version.empty?
  end
end
