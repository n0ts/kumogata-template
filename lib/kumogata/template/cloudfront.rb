#
# Helper - CloudFront
#
require 'kumogata/template/helper'

def _cloudfront_distribution_config(args)
  aliases = args[:aliases] || []
  cache =
    if args.key? :cache
      _cloudfront_cache_behavior(args[:cache])
    else
      ""
    end
  comment = args[:comment] || ""
  custom_errors =
    if args.key? :custom_errors
      _cloudfront_custom_errors(args[:custom_errors])
    else
      []
    end
  default_cache =
    if args.key? :default_cache
      _cloudfront_cache_behavior(args[:default_cache], true)
    else
      ""
   end
  default_root = args[:default_root] || "index.html"
  enabled = _bool("enabled", args, true)
  http = _valid_values(args[:http], %w( http1.1 http2 ), "http2")
  logging =
    if args.key? :logging
      _cloudfront_logging(args[:logging])
    else
      ""
    end
  origins = _cloudfront_origins(args[:origins])
  price = args[:price] || ""
  restrictions = args[:restrictions] || ""
  viewer_cert =
    if args.key? :viewer_cert
      _cloudfront_viewer_cert(args[:viewer_cert])
    else
      ""
    end
  web_acl = args[:web_acl] || ""

  _{
    Aliases aliases unless aliases.empty?
    CacheBehaviors cache unless comment.empty?
    Comment comment unless comment.empty?
    CustomErrorResponses custom_errors unless custom_errors.empty?
    DefaultCacheBehavior default_cache unless default_cache.empty?
    DefaultRootObject default_root unless default_root.empty?
    Enabled enabled
    HttpVersion http unless http.empty?
    Logging logging unless logging.empty?
    Origins origins
    PriceClass price unless price.empty?
    Restrictions restrictions unless restrictions.empty?
    ViewerCertificate viewer_cert unless viewer_cert.empty?
    WebACLId web_acl unless web_acl.empty?
  }
end

def _cloudfront_cache_behavior(args, default = false)
  allowed_methods =
    if args.key? :allowed_methods
      case args[:allowed_methods]
       when "with options"
        %w( GET HEAD OPTIONS )
       when "all"
        %w( DELETE GET HEAD OPTIONS PATCH POST PUT )
       else
        %w( HEAD GET )
      end
    else
      ""
    end
  cached_methods =
    if args.key? :cached_methods
      case args[:cached_methods]
      when "with options"
        %w( GET HEAD OPTIONS )
      else
        %w( HEAD GET )
      end
    else
      ""
    end
  compress =
    if args.key? :compress
      _bool("compress", args, false)
    else
      ""
    end
  default_ttl = args[:default_ttl] || nil
  forwarded_values =
    if args.key? :forwarded
      _cloudfront_forwarded_values(args[:forwarded])
    else
      ""
    end
  max_ttl = args[:max_ttl] || ""
  min_ttl = args[:min_ttl] || ""
  path = args[:path]
  smooth =
    if args.key? :smooth
      _bool(args[:smooth])
    else
      ""
    end
  target = args[:target]
  trusted = args[:trusted] || ""
  viewer = _valid_values(args[:viewer], %w( allow-all redirect-to-https https-only ), "redirect-to-https")

  _{
    AllowedMethods allowed_methods unless allowed_methods.empty?
    CachedMethods cached_methods unless cached_methods.empty?
    Compress compress unless compress.empty?
    DefaultTTL default_ttl unless default_ttl.nil?
    ForwardedValues forwarded_values
    MaxTTL max_ttl unless max_ttl.empty?
    MinTTL min_ttl unless min_ttl.empty?
    PathPattern path if default == false
    SmoothStreaming smooth unless smooth.empty?
    TargetOriginId target
    TrustedSigners trusted unless trusted.empty?
    ViewerProtocolPolicy viewer
  }
end

def _cloudfront_forwared_cookies(args)
  forward = args[:forward] || ""
  white_lists = args[:white_lists] || ""

  _{
    Forward forward
    WhitelistedNames white_lists
  }
end

def _cloudfront_forwarded_values(args)
  cookies =
    if args.key? :cookies
      _cloudfront_forwared_cookies(args[:cookies])
    else
      ""
    end
  headers = args[:headers] || []
  query_string = _bool("query_string", args, false)
  query_string_keys = args[:query_string_keys] || []

  _{
    Cookies cookies unless cookies.empty?
    Headers headers unless headers.empty?
    QueryString query_string
    QueryStringCacheKeys query_string_keys unless query_string_keys.empty?
  }
end

def _cloudfront_custom_error(args)
  error_min_ttl = args[:error_min_ttl] || ""
  error_code = args[:error_code] || 404
  response_code =
    if args.key? :response_code
      args[:response_code] || 404
    else
      error_code
    end
  response_page =
    unless response_code.nil?
      args[:response_page] || "/#{response_code}.html"
    else
      ""
    end

  _{
    ErrorCachingMinTTL error_min_ttl unless error_min_ttl.empty?
    ErrorCode error_code
    ResponseCode response_code unless response_code.nil?
    ResponsePagePath response_page unless response_page.empty?
  }
end

def _cloudfront_custom_errors(args)
  errors = args || []

  array = []
  errors.each do |error|
    array << _cloudfront_custom_error(error)
  end
  array
end

def _cloudfront_logging(args)
  bucket = _ref_attr_string("bucket", "DomainName", args, "bucket")
  include_cookies =
    if args.key? :include_cookies
      _bool("include_cookies", args, false)
    else
      ""
    end
  prefix = args[:prefix] || ""

  _{
    Bucket bucket
    IncludeCookies include_cookies unless include_cookies.empty?
    Prefix prefix unless prefix.empty?
  }
end

def _cloudfront_origin(args)
  custom =
    if args.key? :custom
      _cloudfront_custom_origin(args[:custom])
    else
      nil
    end
  domain = _ref_attr_string("domain", "DomainName", args, "bucket")
  id = args[:id]
  headers =
    if args.key? :headers
      _cloudfront_origin_headers(args[:headers])
    else
      ""
    end
  path = args[:origin_path] || ""
  s3 =
    if args.key? :s3
      _cloudfront_s3_origin(args[:s3])
    else
      nil
    end

  _{
    CustomOriginConfig custom if s3.nil?
    DomainName domain
    Id id
    OriginCustomHeaders headers unless headers.empty?
    OriginPath path unless path.empty?
    S3OriginConfig s3 if custom.nil?
  }
end

def _cloudfront_origins(args)
  origins = args || []

  array = []
  origins.each do |origin|
    array << _cloudfront_origin(origin)
  end
  array
end

def _cloudfront_custom_origin(args)
  http_port = args[:http_port] || ""
  https_port = args[:https_port] || ""
  origin_protocol = args[:origin_protocol] || ""
  origin_ssl_protocols = args[:origin_ssl_protocols] || []

  _{
    HTTPPort http_port unless http_port.empty?
    HTTPSPort https_port unless https_port.empty?
    OriginProtocolPolicy origin_protocol unless origin_protocol.empty?
    OriginSSLProtocols origin_ssl_protocols unless origin_ssl_protocols.empty?
  }
end

def _cloudfront_s3_origin(args)
  origin = args[:origin] || ""

  _{
    OriginAccessIdentity origin unless origin.empty?
  }
end

def _cloudfront_origin_headers(args)
  name = args[:name]
  value = args[:value]

  _{
    HeaderName name
    HeaderValue value
  }
end

def _cloudfront_viewer_cert(args)
  acm = _ref_string("acm", args)
  default =
    if args.key? :default
      _bool("default", args, false)
    else
      ""
    end
  iam = args[:iam] || ""
  min_protocol = args[:min_protocol] || ""
  ssl = _valid_values(args[:ssl], %w( vip sni-only ), "sni-only")

 _{
   AcmCertificateArn acm unless acm.empty?
   CloudFrontDefaultCertificate default_cert unless default.empty?
   IamCertificateId iam unless iam.empty?
   MinimumProtocolVersion min_protocol unless min_protocol.empty?
   SslSupportMethod ssl unless acm.empty? and iam.empty?
  }
end
