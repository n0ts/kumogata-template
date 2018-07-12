#
# Cognito Identity Pool resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-cognito-identitypool.html
#
require 'kumogata/template/helper'
require 'kumogata/template/cognito'

name = _resource_name(args[:name], "identity pool")
pool = _name("pool", args, "_")
allow_unauth = _bool("unauth", args, false)
developer = _ref_string_default("developer", args)
supported = args[:supported] || ""
providers = _cognito_providers(args)
saml_providers = args[:saml_providers] || []
open_id_providers = args[:open_id_providers] || []
stream = args[:stream] || ""
push_sync = _cognito_push_sync(args)
events = args[:events] || ""

_(name) do
  Type "AWS::Cognito::IdentityPool"
  Properties do
    IdentityPoolName pool
    AllowUnauthenticatedIdentities allow_unauth
    DeveloperProviderName developer unless developer.empty?
    SupportedLoginProviders supported unless supported.empty?
    CognitoIdentityProviders providers unless providers.empty?
    SamlProviderARNs saml_providers unless saml_providers.empty?
    OpenIdConnectProviderARNs open_id_providers unless open_id_providers.empty?
    CognitoStreams stream unless stream.empty?
    PushSync push_sync unless push_sync.empty?
    CognitoEvents events unless events.empty?
  end
end
