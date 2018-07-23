#
# Cognito User Pool User resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-cognito-userpooluser.html
#
require 'kumogata/template/helper'
require 'kumogata/template/cognito'

name = _resource_name(args[:name], "user pool user")
mediums = args[:mediums] || [ 'sms' ]
force = _bool("force", args, false)
attributes = (args[:attributes] || []).collect{|v| _pair_name_value({ attribute: v }, 'attribute') }
message = _valid_values(args, %w( resend suppress ), "")
user = _name("user", args)
pool = _ref_string("pool", args, "user pool")
validations = (args[:validations] || []).collect{|v| _pair_name_value({ validation: v }, 'validation') }

_(name) do
  Type "AWS::Cognito::UserPoolUser"
  Properties do
    DesiredDeliveryMediums mediums.collect{|v| v.upcase }
    ForceAliasCreation force
    UserAttributes attributes.flatten unless attributes.empty?
    MessageAction message.upcase unless message.empty?
    Username user
    UserPoolId pool
    ValidationData validations.flatten unless validations.empty?
  end
end
