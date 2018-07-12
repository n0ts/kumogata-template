#
# EMR security configuration
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-emr-securityconfiguration.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "emr security configuration")
security = _name("security", args)
configuration = args[:configuration] || {}

_(name) do
  Type "AWS::EMR::SecurityConfiguration"
  Properties do
    Name security
    SecurityConfiguration configuration
  end
end
