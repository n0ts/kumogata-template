#
# Helper - ALB
#
require 'kumogata/template/helper'

def _alb_to_lb_attribute_access_log(args)
  {
    "access_logs.s3.enabled": true,
    "access_logs.s3.bucket": args[:bucket],
    "access_logs.s3.prefix": args[:prefix],
  }
end

def _alb_to_lb_attribute_delete_protection
  {
    "deletion_protection.enabled": true
  }
end

def _alb_to_lb_attribute_idle_timeout(value)
  # idle timeout seconds 1-3600
  {
    "idle_timeout.timeout_seconds": value
  }
end

def _alb_to_target_group_attribute_delay_timeout(value)
  # wait before changing the state of a deregistering target from draining to unused 0-3600 seconds.
  {
    "deregistration_delay.timeout_seconds": value
  }
end

def _alb_to_target_group_stickiness(value)
  # 1 second to 1 week (604800 seconds). The default value is 1 day (86400 seconds).
  {
    "stickiness.enabled": true,
    "stickiness.type": "lb_cookie",
    "stickiness.lb_cookie.duration_seconds": value
  }
end

def _alb_certificates(args)
  certificate = _ref_string("certificate", args)

  [
   _{
     CertificateArn certificate
   }
  ]
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
  ref_targets = args[:ref_targets] || []

  array = []
  targets.each do |target|
    id = _ref_string("instance", target, "instance")
    array << _{
      Id id
      Port target[:port] if target.key? :port
    }
  end

  ref_targets.each do |target|
    array << _{
      Id _ref_string("instance", { ref_instance: target }, "instance")
      Port 80
    }
  end

  array
end
