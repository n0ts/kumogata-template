#
# Helper - Api Gateway
#
require 'kumogata/template/helper'

def _api_gateway_to_parameter(args)
  type = _valid_values(args[:type], %w( integration method ), "method")
  location = _valid_values(args[:location], %w( querystring path header ), "path")
  operation = args[:operation] || "request"
  "#{type}.#{operation}.#{location}.#{args[:name]}"
end

def _api_gateway_to_parameter_headers(kind)
  headers =
    case kind
    when "aws"
      [
       { name: "X-AWS-Request-Id", value: "context.requestId" },
       { name: "X-AWS-API-Id", value: "context.apiId" },
      ]
    when "cognito"
      [
       { name: "X-AWS-Cognito-Identity-Id", value: "context.identity.cognitoIdentityId" },
       { name: "X-AWS-Cognito-Identity-Pool-Id", value: "context.identity.cognitoIdentityPoolId" },
       { name: "X-AWS-Cognito-Authentication-Type", value: "context.identity.cognitoAuthenticationType" },
       { name: "X-AWS-Cognito-Authentication-Provider", value: "context.identity.cognitoAuthenticationProvider" },
      ]
    else
      []
    end
  return headers if headers.empty?

  headers.collect{|v| v.merge!({ location: "header" }) }
end

def _api_gateway_to_parameter_response_headers(args = {})
  headers = {}
  key = _api_gateway_to_parameter({ operation: "response",
                                    location: "header",
                                    name: "Access-Control-Allow-Methods" })
  headers[key] = "'DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT'"

  key = _api_gateway_to_parameter({ operation: "response",
                                    location: "header",
                                    name: "Access-Control-Allow-Headers" })
  allow_headers = %w( Content-Type Authorization X-Amz-Date X-Api-Key X-Amz-Security-Token)
  allow_headers += args[:allow_headers] if args.key? :allow_headers
  headers[key] = sprintf("'%s'", allow_headers.join(','))

  key = _api_gateway_to_parameter({ operation: "response",
                                    location: "header",
                                    name: "Access-Control-Allow-Origin" })
  headers[key] = "'*'"

  headers
end

def _api_gateway_stage_keys(args)
  (args[:stage_keys] || []).collect do |key|
    rest = _ref_string("rest", key, "reset api")
    stage = _ref_string("stage", key)
    _{
      RestApiId rest
      StageName stage
    }
  end
end

def _api_gateway_integration(args)
  args_proxy = _bool("proxy", args, false)
  args_parameters = args[:parameters] || []

  integration = args[:integration] || {}
  return integration if integration.empty?

  cache_keys = integration[:cache_keys] || []
  cache_keys << _api_gateway_to_parameter({ type: "method", location: "path", name: "proxy" }) if args_proxy
  cache_ns = integration[:cache_ns] || ""
  http =
    if args_proxy
      "any"
    else
      _valid_values(integration[:http], %w( delete get head options patch post put any ), "any")
    end
  responses =
    if integration.key? :responses
      integration[:responses].collect{|v| _api_gateway_integration_response(v) }
    else
      []
    end
  responses << _api_gateway_integration_response({ template: { "application/json": "null" } }) if args_proxy
  pass =
    if args_proxy
      "when_no_match"
    else
      _valid_values(integration[:pass], %w( when_no_match when_no_templates never ), "")
    end
  role = _ref_attr_string("role", "Arn", integration)
  parameters = {}
  args_parameters.collect do |v|
    k = _api_gateway_to_parameter({ type: "integration", location: v[:location], name: v[:name] })
    parameters[k] = _api_gateway_to_parameter(v)
  end
  (integration[:parameters] || []).collect do |v|
    k = _api_gateway_to_parameter({ type: "integration", location: v[:location], name: v[:name] })
    parameters[k] = v[:value]
  end
  # RequestTemplates
  # - Key: The content type value
  # - Value: the template http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-mapping-template-reference.html
  templates = integration[:templates] || {}
  type =
    if args_proxy
      "http_proxy"
    else
      _valid_values(integration[:type], %w( mock http http_proxy aws aws_proxy ), "http")
    end

  uri =
    case type
    when /http/
      _ref_string("uri", integration)
    when /aws/
      _iam_arn("api-gateway", integration)
    else
      ""
    end
  uri = _join([ uri, "{proxy}" ], "/") if args_proxy

  _{
    CacheKeyParameters cache_keys unless cache_keys.empty?
    CacheNamespace cache_ns unless cache_ns.empty?
    Credentials role unless role.empty?
    IntegrationHttpMethod http.upcase if type != "mock"
    IntegrationResponses responses unless responses.empty?
    PassthroughBehavior pass.upcase unless pass.empty?
    RequestParameters parameters unless parameters.empty?
    RequestTemplates templates unless templates.empty?
    Type type.upcase
    Uri uri unless uri.empty?
  }
end

def _api_gateway_integration_response(args)
  parameter = args[:parameter] || {}
  template = args[:template] || {}
  selection = args[:selection] || ""
  status = args[:status] || 200

  _{
    ResponseParameters parameter unless parameter.empty?
    ResponseTemplates template unless template.empty?
    SelectionPattern selection unless selection.empty?
    StatusCode status
  }
end

def _api_gateway_responses(args)
  (args[:responses] || []).collect do |response|
    models = response[:models] || []
    parameters = response[:parameters] || []
    status = response[:status] || 200

    _{
      ResponseModels models unless models.empty?
      ResponseParameters parameters unless parameters.empty?
      StatusCode status
    }
  end
end

def _api_gateway_stage_description(args)
  description = args[:stage_description] || {}
  return description if description.empty?

  cache = description[:cache] || {}
  certificate = _ref_string_default("certificate", description, "certificate")
  data_trace = _bool("data_trace", description, false)
  description_desc = description[:description] || ""
  logging = _valid_values(description[:logging], %w( off error info ), "off")
  method = _api_gateway_method_settings(description)
  metrics = _bool("metrics", description, false)
  stage = _name("stage", description)
  throtting = description[:throtting] || {}
  variables = description[:variables] || {}

  _{
    CacheClusterEnabled true if cache.key? :cluster
    CacheClusterSize cache[:size] unless cache.empty?
    CacheDataEncrypted true if cache.key? :encrypted
    CacheTtlInSeconds cache[:ttl] unless cache.empty?
    CachingEnabled cache.empty? ? false : true
    ClientCertificateId certificate unless certificate.empty?
    DataTraceEnabled data_trace
    Description description unless description_desc.empty?
    LoggingLevel logging.upcase
    MethodSettings method unless method.empty?
    MetricsEnabled metrics
    StageName stage
    ThrottlingBurstLimit throtting[:burst] unless throtting.empty?
    ThrottlingRateLimit throtting[:rate] unless throtting.empty?
    Variables variables unless variables.empty?
  }
end

def _api_gateway_method_settings(args)
  (args[:settings] || []).collect do |setting|
    cache = setting[:cache] || {}
    data_trace = _bool("data_trace", setting, false)
    http = setting[:http] || "*"
    logging = _valid_values(setting[:logging], %w( off error info ), "info")
    metrics = _bool("metrics", setting, false)
    resource = setting[:resource] || "/*"
    throtting = setting[:throtting] || {}

    _{
      CacheDataEncrypted cache[:encrypted] unless cache.empty?
      CacheTtlInSeconds cache[:ttl] unless cache.empty?
      CachingEnabled cache.empty? ? false : true
      DataTraceEnabled data_trace
      HttpMethod http
      LoggingLevel logging.upcase
      MetricsEnabled metrics
      ResourcePath resource
      ThrottlingBurstLimit throtting[:burst] unless throtting.empty?
      ThrottlingRateLimit throtting[:rate] unless throtting.empty?
    }
  end
end

def _api_gateway_stages(args)
  (args[:stages] || []).collect do |stage|
    _{
      ApiId _ref_string("rest", stage, "rest api")
      Stage _ref_string("stage", stage, "stage")
    }
  end
end

def _api_gateway_quota(args)
  quota = args[:quota] || {}
  return quota if quota.empty?

  offset = quota[:offset] || ""
  period = _valid_values(quota[:period], %w( day week month ), "month")

  _{
    Limit quota[:limit]
    Offset offset unless offset.empty?
    Period period.upcase
  }
end

def _api_gateway_throttle(args)
  throttle = args[:throttle] || {}
  return throttle if throttle.empty?

  _{
    BurstLimit throttle[:bust]
    RateLimit throttle[:rate]
  }
end
