#
# Helper - Cognito
#
require 'kumogata/template/helper'

def _cognito_providers(args)
  providers = args[:providers] || {}
  return providers if providers.empty?

  # providers: [ ref_client: 'admin', ref_name: 'admin' ]
  providers.collect do |provider|
    _{
      ClientId _ref_string("client", provider, "user pool client")
      ProviderName _ref_attr_string("pool", "ProviderName", provider, "user pool")
      ServerSideTokenCheck _bool("check", provider, false)
    }
  end
end

def _cognito_streams(args)
  stream = args[:stream] || {}
  return stream if stream.empty?

  _{
    RoleArn stream[:role]
    StreamingStatus _bool("status", stream, false) ? "ENABLED" : "DISABLED"
    StreamName stream[:name]
  }
end

def _cognito_push_sync(args)
  push_sync = args[:push_sync] || {}
  return push_sync if push_sync.empty?

  _{
    ApplicationArns push_sync[:applications]
    RoleArn push_sync[:role]
  }
end

def _cognito_roles_mappings(args)
  # T.B.D
end

def _cognito_roles(args)
  roles = args[:roles] || {}
  return roles if roles.empty?

  unauth = _ref_attr_string("unauth", "Arn", roles, "role")
  auth = _ref_attr_string("auth", "Arn", roles, "role")

  _{
    unauthenticated unauth unless unauth.empty?
    authenticated auth
  }
end

def _cognito_admin_config(args)
  admin_config = args[:admin_config] || {}
  return admin_config if admin_config.empty?

  invite = _cognito_invite(admin_config)
  unused = admin_config[:unused] || 7

  _{
    AllowAdminCreateUserOnly _bool("allow", admin_config, false)
    InviteMessageTemplate invite unless invite.empty?
    UnusedAccountValidityDays unused
  }
end

def _cognito_invite(args)
  invite = args[:invite] || {}
  return invite if invite.empty?

  email_message = _ref_string_default("email_message", invite,
                                      "Your username is {username} and temporary password is {####}.")
  email_subject = _ref_string_default("email_subject", invite,
                                      "Your temporary password")
  sms = _ref_string_default("sms", invite,
                            "Your username is {username} and temporary password is {####}.")

  _{
    EmailMessage email_message
    EmailSubject email_subject
    SMSMessage sms
  }
end

def _cognito_device_config(args)
  device_config = args[:device_config] || {}
  return device_config if device_config.empty?

  _{
    ChallengeRequiredOnNewDevice _bool("challenge", device_config, false)
    DeviceOnlyRememberedOnUserPrompt _bool("device_only", device_config, false)
  }
end

def _cognito_email_config(args)
  email_config = args[:email_config] || {}
  return email_config if email_config.empty?

  reply_to = _ref_string_default("reply_to", email_config)
  source = _ref_string_default("source", email_config)

  _{
    ReplyToEmailAddress reply_to unless reply_to.empty?
    SourceArn source
  }
end

def _cognito_email_verify(args)
  email_verify = args[:email_verify] || {}
  return {} if email_verify.empty?

  {
    message: email_verify[:message] || "Your verification code is {####}.",
    subject: email_verify[:subject] || "Your verification code",
  }
end

def _cognito_lambda_config(args)
  lambda_config = args[:lambda_config] || {}
  return {} if lambda_config.empty?

  create_auth = _ref_string_default("create_auth", lambda_config)
  custom_message = _ref_string_default("custom_message", lambda_config)
  defined_auth = _ref_string_default("defined_auth", lambda_config)
  post_auth = _ref_string_default("post_auth", lambda_config)
  post_confirm = _ref_string_default("post_confirm", lambda_config)
  pre_auth = _ref_string_default("pre_auth", lambda_config)
  pre_sign = _ref_string_default("pre_sign", lambda_config)
  verify_auth = _ref_string_default("verify_auth", lambda_config)

  _{
    CreateAuthChallenge create_auth unless create_auth.empty?
    CustomMessage custom_message unless custom_message.empty?
    DefineAuthChallenge defined_auth unless defined_auth.empty?
    PostAuthentication post_auth unless post_auth.empty?
    PostConfirmation post_confirm unless post_confirm.empty?
    PreAuthentication pre_auth unless pre_auth.empty?
    PreSignUp pre_sign unless pre_sign.empty?
    VerifyAuthChallengeResponse verify_auth unless verify_auth.empty?
  }
end

def _cognito_policies(args)
  policies = args[:policies] || {}
  password = _cognito_password_policy(policies)

  _{
    PasswordPolicy password
  }
end

def _cognito_password_policy(args)
  policy = args[:password] || {}

  _{
    MinimumLength policy[:min] || 6
    RequireLowercase _bool("lowercase", policy, false)
    RequireNumbers _bool("numbers", policy, false)
    RequireSymbols _bool("symbols", policy, false)
    RequireUppercase _bool("uppercase", policy, false)
  }
end

def _cognito_schemas(args)
  (args[:schemas] || []).collect do |schema|
    data_type = schema[:data_type] || "String" # String, Number, DateTime, or Boolean
    number = schema[:number] || {}
    string = schema[:string] || {}

    _{
      AttributeDataType data_type unless data_type.empty?
      DeveloperOnlyAttribute _bool("developer", schema, false)
      Mutable _bool("mutable", schema, true)
      Name schema[:name]
      NumberAttributeConstraints do
        MaxValue number[:max]
        MinValue number[:min]
      end unless number.empty?
      StringAttributeConstraints do
        MaxLength string[:max]
        MinLength string[:min]
      end unless string.empty?
      Required _bool("required", schema, true)
    }
  end
end

def _cognito_sms_config(args)
  sms_config = args[:sms_config] || {}
  return sms_config if sms_config.empty?

  external = _ref_string_default("external", sms_config)

  _{
    ExternalId external unless external.empty?
    SnsCallerArn _ref_string("sns_caller", args)
  }
end
