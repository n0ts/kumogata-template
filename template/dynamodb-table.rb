#
# DynamoDB Table resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-dynamodb-table.html
#
require 'kumogata/template/helper'
require 'kumogata/template/dynamodb'

name = _resource_name(args[:name], "table")
attribute = _dynamodb_attribute(args[:attribute])
global = (args[:global] || []).collect{|v| _dynamodb_global(v) }
key_schema = _dynamodb_key_schema(args[:key_schema])
local = (args[:local] || []).collect{|v| _dynamodb_local(v) }
provisioned = _dynamodb_provisioned(args[:provisioned] || [])
stream =
  if args.key? :stream
    _dynamodb_stream(args[:stream])
  else
    []
  end
table = _name("table", args)
tags = _tags(args, "table")
ttl = _dynamodb_ttl(args)

_(name) do
  Type "AWS::DynamoDB::Table"
  Properties do
    AttributeDefinitions attribute
    GlobalSecondaryIndexes global unless global.empty?
    KeySchema key_schema
    LocalSecondaryIndexes local unless local.empty?
    ProvisionedThroughput provisioned
    StreamSpecification stream unless stream.empty?
    TableName table
    Tags tags
    TimeToLiveSpecification ttl unless ttl.empty?
  end
end
