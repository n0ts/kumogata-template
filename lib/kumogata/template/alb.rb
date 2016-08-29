#
# Helper - ALB
#
require 'kumogata/template/helper'

def _alb_certificates(args)
  certificates = args[:certificates] || []

  array = []
  certificates.each do |certificate|
    cert = _ref_string("value", { value: certificate }, "certificate")
    next if cert.empty?

    array << _{
      CertificateArn cert
    }
  end
  array
end

def _alb_actions(args)
  defaults = args[:actions] || []

  array = []
  defaults.each do |default|
    target = _ref_string("target", default, "target group")
    array << _{
      TargetGroupArn target
      Type "forward"
    }
  end
  array
end

def _alb_conditions(args)
  conditions = args[:conditions] || []

  array = []
  conditions.each do |condition|
    condition = [ condition ] unless condition.is_a? Array
    array << _{
      Field "path-pattern"
      Values condition
    }
  end
  array
end

def _alb_attributes(args)
  attributes = args[:attributes] || []

  array = []
  attributes.each do |attribute|
    attribute.each_pair{|key, value|
      array << _{
        Key key
        Value value
      }
    }
  end
  array
end

def _alb_matcher(args)
  args[:matcher] = 200 unless args.key? :matcher

  http_code = _valid_values(args[:matcher], %w( 200 202 299 ), 200)
  _{
    HttpCode http_code
  }
end

def _alb_health_check(args)
  protocol = _valid_values(args[:protocol] || "", %w( http https ), "http")
  # Return to native hash
  {
    interval: args[:interval] || 30,
    path: args[:path] || "/",
    port: args[:port] || 80,
    protocol: protocol.upcase,
    timeout: args[:timeout] || 5,
    healthy: args[:healthy] || 10,
    unhealthly: args[:unhealthly] || 2,
  }
end

def _alb_targets(args)
  targets = args[:targets] || []

  array = []
  targets.each do |target|
    id = _ref_string("instance", target, "instance")
    array << _{
      Id id
      Port target[:port] if target.key? :port
    }
  end
  array
end
