#
# Cognito User Pool resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-cognito-userpool.html
#
require 'kumogata/template/helper'
require 'kumogata/template/cognito'

name = _resource_name(args[:name], "user pool")
admin_config = _cognito_admin_config(args)
aliases = args[:aliases] || [] # phone_number, email, and/or preferred_username
auto_verifies = args[:auto_verifies] || [ "email" ] # email and/or phone_number
device_config = _cognito_device_config(args)
email_config = _cognito_email_config(args)
email_verify = _cognito_email_verify(args)
lambda_config = _cognito_lambda_config(args)
mfa = _valid_values(args[:mfa], %w( off on optional ), "")
policies = _cognito_policies(args)
pool_name = _name("pool", args)
schemas = _cognito_schemas(args)
sms_auth = args[:sms_auth] || ""
sms_config = _cognito_sms_config(args)
sms_verify = _ref_string_default("sms_verify", args)
tags = _tags_string(args, "pool")

_(name) do
  Type "AWS::Cognito::UserPool"
  Properties do
    AdminCreateUserConfig admin_config unless admin_config.empty?
    AliasAttributes aliases unless aliases.empty?
    AutoVerifiedAttributes auto_verifies
    DeviceConfiguration device_config unless device_config.empty?
    EmailConfiguration email_config unless email_config.empty?
    EmailVerificationMessage email_verify[:message] unless email_verify.empty?
    EmailVerificationSubject email_verify[:subject] unless email_verify.empty?
    LambdaConfig lambda_config unless lambda_config.empty?
    MfaConfiguration mfa.upcase unless mfa.empty?
    Policies policies
    UserPoolName pool_name
    Schema schemas unless schemas.empty?
    SmsAuthenticationMessage sms_auth unless sms_auth.empty?
    SmsConfiguration sms_config unless sms_config.empty?
    SmsVerificationMessage sms_verify unless sms_verify.empty?
    UserPoolTags tags
  end
end
