#
# Api Gateway Resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-apigateway-resource.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "resource")
parent_key =
  if _ref_key? "parent", args
    "parent"
  else
    "rest"
  end
parent = _ref_attr_string(parent_key, "RootResourceId", args, "rest api")
proxy = _bool("proxy", args, false)
path =
  if proxy
    "{proxy+}"
  else
    _ref_string("path", args)
  end
path = path.gsub(/^\//, "") if path.is_a? String
rest = _ref_string("rest", args, "rest api")

_(name) do
  Type "AWS::ApiGateway::Resource"
  Properties do
    ParentId parent
    PathPart path
    RestApiId rest
  end
end
