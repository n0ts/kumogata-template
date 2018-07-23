#
# Helper - S3
#
require 'kumogata/template/helper'

def _s3_to_deletion_policy(value)
  return "Retain" if value.nil?

  case value
  when "delete"
    "Delete"
  when "retain"
    "Retain"
  when "shapshot"
    "Snapshot"
  else
    _valid_values(value, %w( Delete Retain Snapshot ), "Retain")
  end
end

def _s3_to_access(value)
  return "Private" if value.nil?

  case value
  when "auth read"
    "AuthenticatedRead"
  when "aws exec read"
    "AwsExecRead"
  when "owner read"
    "BucketOwnerRead"
  when "owner full"
    "BucketOwnerFullControl"
  when "log delivery write"
    "LogDeliveryWrite"
  when "private"
    "Private"
  when "public read"
    "PublicRead"
  when "public read write"
    "PublicReadWrite"
  else
    value
  end
end

def _s3_to_lifecycle_storage(value)
  case value
  when "ia"
    "STANDARD_IA"
  else
    "GLACIER"
  end
end

def _s3_to_lifecycle_move_to_glacier(exp_in_days = 1, trans_in_days = 1, prefix = "")
  lifecycle = {
    exp_in_days: exp_in_days,
    id: "lifecycle rule - move to glacier expiration / transition in days: #{exp_in_days} / #{trans_in_days}",
    transitions: [
                   { storage: "glacier", in_days: trans_in_days },
                  ],
  }
  lifecycle[:prefix] = prefix unless prefix.empty?
  lifecycle
end

def _s3_to_notification_event_type(value)
  type =
    case value
    when 'create all', 'new'
      'ObjectCreated:*'
    when 'put'
      'ObjectCreated:Put'
    when 'post'
      'ObjectCreated:Post'
    when 'copy'
      'ObjectCreated:Copy'
    when 'upload'
      'ObjectCreated:CompleteMultipartUpload'
    when 'delete all', 'remove all'
      'ObjectRemoved:*'
    when 'delete'
      'ObjectRemoved:Delete'
    when 'delete marker'
      'ObjectRemoved:DeleteMarkerCreated'
    when 'lost'
      'ReducedRedundancyLostObject'
    end
  "s3:#{type}"
end

def _s3_cors(args)
  rules = (args[:cors] || []).collect do |rule|
    _{
      AllowedHeaders _array(rule[:headers]) if rule.key? :headers
      AllowedMethods _array(rule[:methods])
      AllowedOrigins _array(rule[:origins])
      ExposedHeaders _array(rule[:exposed_headers]) if rule.key? :exposed_headers
      Id rule[:id] if rule.key? :id
      MaxAge rule[:max_age] if rule.key? :max_age
    }
  end
  return rules if rules.empty?

  _{
    CorsRules rules
  }
end

def _s3_lifecycle(args)
  rules = (args[:lifecycles] || []).collect do |rule|
    noncurrent_transitions = _s3_lifecycle_noncurrent_version_transition(rule)
    status =
      if rule.key? :status
        _bool('status', rule, true) ? "Enabled" : "Disabled"
      else
        "Enabled"
      end
    transitions = _s3_lifecycle_transition(rule)

    _{
      ExpirationDate _timestamp_utc(rule[:exp_date]) if rule.key? :exp_date
      ExpirationInDays rule[:exp_in_days] if rule.key? :exp_in_days
      Id rule[:id] if rule.key? :id
      NoncurrentVersionExpirationInDays rule[:non_exp_in_days] if rule.key? :non_exp_in_days
      NoncurrentVersionTransitions noncurrent_transitions unless noncurrent_transitions.empty?
      Prefix rule[:prefix] if rule.key? :prefix
      Status status
      Transitions transitions unless transitions.empty?
    }
  end
  return rules if rules.empty?

  _{
    Rules rules
  }
end

def _s3_lifecycle_noncurrent_version_transition(args)
  (args[:noncurrent_version_transitions] || []).collect do |transition|
    _{
      StorageClass _s3_to_lifecycle_storage(transition[:storage])
      TransitionInDays transition[:in_days]
    }
  end
end

def _s3_lifecycle_transition(args)
  (args[:transitions] || []).collect do |transition|
    _{
      StorageClass _s3_to_lifecycle_storage(transition[:storage])
      TransitionDate _timestamp_utc(transition[:date]) if transition.key? :date
      TransitionInDays transition[:in_days]
    }
  end
end

def _s3_logging(args)
  logging = args[:logging] || {}
  return logging if logging.empty?

  _{
    DestinationBucketName logging[:destination]
    LogFilePrefix logging[:prefix] || ""
  }
end

def _s3_notification(args)
  notification = args[:notification] || {}
  return notification if notification.empty?

  lambda = _s3_notification_configuration(notification, :lambda)
  queue = _s3_notification_configuration(notification, :queue)
  topic = _s3_notification_configuration(notification, :topic)

  _{
    LambdaConfigurations lambda unless lambda.empty?
    QueueConfigurations queue unless queue.empty?
    TopicConfigurations topic unless topic.empty?
  }
end

def _s3_notification_configuration(args, key)
  return {} unless args.key? key.to_sym

  args[key.to_sym].collect do |value|
    _{
      Event _s3_to_notification_event_type(value[:event])
      Filter _{
        S3Key _{
          Rules value[:filters].collect{|v|
            filter = []
            v.each_pair do |kk, vv|
              filter << _{
                Name kk
                Value vv
              }
            end
            filter
          }.flatten
        }
      } if value.key? :filters
      case key.to_sym
      when :lambda
        Function _ref_attr_string("function", "Arn", value, "lambda function", "arn")
      when :queue
        Queue _ref_attr_string("queue", "Arn", value, "queue")
      when :topic
        Topic _ref_string("topic", value, "topic")
      end
    }
  end
end

def _s3_replication(args)
  replication = args[:replication] || {}
  return replication if replication.empty?

  rules = _s3_replication_rules(replication)

  _{
    Role replication[:role]
    Rules rules
  }
end

def _s3_replication_rules(args)
  (args[:rules] || []).collect do |rule|
    destination = _s3_replication_rules_destination(rule[:destination])
    _{
      Destination destination
      Id rule[:id]
      Prefix rule[:prefix]
      Status rule[:status]
    }
  end
end

def _s3_replication_rules_destination(args)
  _{
    Bucket args[:bucket]
    StorageClass args[:storage]
  }
end

def _s3_versioning(args)
  return "" unless args.key? :versioning

  status =
    if _bool("versioning", args, false)
      "Enabled"
    else
      "Suspended"
    end
  _{
    Status status
  }
end

def _s3_website(args)
  website = args[:website] || ""
  return website if website.empty?

  redirect = _s3_website_redirect_all_request(website)
  routing = _s3_website_routing_rules(website)

  _{
    ErrorDocument website[:error] || "error.html"
    IndexDocument website[:index] || "index.html"
    RedirectAllRequestsTo redirect unless redirect.empty?
    RoutingRules routing unless routing.empty?
  }
end

def _s3_website_redirect_all_request(args)
  redirect = args[:redirect] || {}
  return redirect if redirect.empty?

  _{
    HostName redirect[:hostname]
    Protocol _valid_values(redirect[:protocol], %w( http https ), "http")
  }
end

def _s3_website_routing_rules(args)
  (args[:routing] || []).collect do |route|
    _{
      RedirectRule do
        redirect = route[:redirect] || {}
        HostName redirect[:host] if redirect.key? :host
        HttpRedirectCode redirect[:http] if redirect.key? :http
        Protocol redirect[:protocol] if redirect.key? :protocol
        ReplaceKeyPrefixWith redirect[:replace_key_prefix] if redirect.key? :replace_key_prefix
        ReplaceKeyWith redirect[:replace_key_with] if redirect.key? :replace_key_with
      end
      RoutingRuleCondition do
        routing = route[:routing] || {}
        HttpErrorCodeReturnedEquals routing[:http]
        KeyPrefixEquals routing[:key_prefix]
      end
    }
  end
end
