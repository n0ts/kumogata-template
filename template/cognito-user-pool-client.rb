#
# Cognito User Pool Client resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-cognito-userpoolclient.html
#
require 'kumogata/template/helper'
require 'kumogata/template/cognito'

name = _resource_name(args[:name], "user pool client")
client = _name("client", args)
auth_flows = args[:auth_flows] || [] # ADMIN_NO_SRP_AUTH or CUSTOM_AUTH_FLOW_ONLY
secret = _bool("secret", args, false)
read_attributes = args[:read_attributes] || []
refresh = args[:refresh] || 30
pool = _ref_string("pool", args, "user pool")
write_attributes = args[:write_attributes] || []

_(name) do
  Type "AWS::Cognito::UserPoolClient"
  Properties do
    ClientName client
    ExplicitAuthFlows auth_flows unless auth_flows.empty?
    GenerateSecret secret
    ReadAttributes read_attributes unless read_attributes.empty?
    RefreshTokenValidity refresh
    UserPoolId pool
    WriteAttributes write_attributes unless write_attributes.empty?
  end
end
