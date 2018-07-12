#
# Helper - ELB
#
require 'kumogata/template/helper'

def _elb_access_logging_policy(args)
  access = args[:access_logging] || ""
  return "" if access.empty?

  _{
    EmitInterval access[:emit] || 5
    Enabled _bool("enabled", access, true)
    S3BucketName access[:s3_bucket]
    S3BucketPrefix access[:s3_bucket_prefix]
  }
end

def _elb_app_cookie_stickiness_policy(args)
  (args[:app_cookie] || []).collect do |app|
    _{
      CookieName app[:cookie]
      PolicyName app[:policy]
     }
  end
end

def _elb_connection_draining_policy(args)
  connection = args[:connection_draining] || {}

  _{
    Enabled _bool("enabled", connection, true)
    Timeout connection[:timeout] || 60
  }
end

def _elb_connection_settings(args)
  connection = args[:connection_settings] || {}

  _{
    IdleTimeout connection[:idle] || 60
  }
end

def _elb_health_check(args)
  health_check = args[:health_check] || {}
  protocol = _valid_values(health_check[:protocol], %w( http https tcp ssl ), "http")
  port = health_check[:port] || case protocol
                            when "http"
                              80
                            when "https"
                              443
                            end
  path = health_check[:path] || "index.html"
  _{
    HealthyThreshold health_check[:healthy] || 10
    Interval health_check[:interval] || 30
    Target "#{protocol.upcase}:#{port}/#{path}"
    Timeout health_check[:timeout] || 5
    UnhealthyThreshold health_check[:unhealthly] || 2
  }
end

def _elb_cookie_stickiness_policy(args)
  (args[:cookie_stickiness] || []).collect do |cookie|
    _{
      CookieExpirationPeriod cookie[:expiration]
      PolicyName cookie[:policy]
    }
  end
end

def _elb_listeners(args)
  listeners = args[:listeners] || []
  listeners = [ { protocol: "http" } ] if listeners.empty?

  listeners.collect do |listener|
    proto = listener[:protocol] || "http"
    protocol = _valid_values(proto, %w( http https tcp ssl ), "http")
    lb_port =
      case protocol
      when "http"
        80
      when "https"
        443
      end
    instance_proto = listener[:instance_protocol] || protocol
    instance_protocol = _valid_values(instance_proto, %w( http https tcp ssl ), "http")
    instance_port =
      case instance_protocol
      when "http"
        80
      when "https"
        443
      end
    policies = []
    if protocol == "https" or protocol == "ssl"
      policy = listener[:policy] || "2016-08"
      policies << "ELBSecurityPolicy-#{policy}"
    end
    ssl = _ref_string("ssl", listener)

    _{
      InstancePort instance_port
      InstanceProtocol instance_protocol.upcase
      LoadBalancerPort lb_port
      PolicyNames policies unless policies.empty?
      Protocol protocol.upcase
      SSLCertificateId ssl if protocol == "https"
    }
  end
end

def _elb_policy_types(args)
  (args[:policy] || []).collect do |policy|
    attributes = []
    instance_ports = []
    lb_ports = []
    policy_name = policy[:name]
    policy_type = policy[:type]

    _{
      Attributes attributes unless attributes.empty?
      InstancePorts instance_ports unless instance_ports.empty?
      LoadBalancerPorts lb_ports unless lb_ports.empty?
      PolicyName policy_name
      PolicyType policy_type
    }
  end
end
