#
# Cognito Identity Pool Role Attachment resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-cognito-identitypoolroleattachment.html
#
require 'kumogata/template/helper'
require 'kumogata/template/cognito'

name = _resource_name(args[:name], "identity pool role attachment")
pool_id = _ref_string("pool", args, "identity pool")
mapping = _ref_string("mapping", args)
roles = _cognito_roles(args)
depends = _depends([ { ref_auth_role: "role" }, { ref_unauth_role: "role" } ], args)

_(name) do
  Type "AWS::Cognito::IdentityPoolRoleAttachment"
  Properties do
    IdentityPoolId pool_id
    RoleMappings mapping unless mapping.empty?
    Roles roles
  end
  DependsOn depends unless depends.empty?
end
