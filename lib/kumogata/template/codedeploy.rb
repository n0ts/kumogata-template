#
# Helper - CodeDeploy
#
require 'kumogata/template/helper'

def _codedeploy_minimum(args)
  type = _valid_values(args[:type], %w( host_count fleet_percent ), "fleet_percent")
  value = args[:value]

  _{
    Type type.upcase
    Value value
  }
end

def _codedeploy_alarm(args)
  alarm = args[:alarm] || ""
  return alarm if alarm.empty?

  alarms = alarm[:alarms].collect{|v| _{ Name v } }
  enabled = _bool("enabled", args, true)
  ignore = _bool("ignore", args, false)

  _{
    Alarms alarms
    Enabled enabled
    IgnorePollAlarmFailure ignore
  }
end

def _codedeploy_deployment(args)
  description = args[:description] || ""
  ignore = _bool("ignore", args, true)
  revision = _codedeploy_revision(args[:revision])

  _{
    Description description unless description.empty?
    IgnoreApplicationStopFailures ignore
    Revision revision
 }
end

def _codedeploy_revision(args)
  github =
    if args.key? :github
      _codedeploy_github(args[:github])
    else
      ""
    end
  s3 =
    if args.key? :s3
      _codedeploy_s3(args[:s3])
    else
      ""
    end

  _{
    GitHubLocation github unless github.empty?
    RevisionType github.empty? ? "S3" : "GitHub"
    S3Location s3 unless s3.empty?
  }
end

def _codedeploy_github(args)
  commit = args[:commit] || ""
  repository = args[:repository] || ""

  _{
    CommitId commit
    Repository repository
  }
end

def _codedeploy_s3(args)
  bucket = _ref_string("bucket", args, "bucket")
  key = _ref_string("key", args)
  bundle = _valid_values(args[:bundle], %w( tar zip ), "zip")
  etag = _ref_string("etag", args)
  version = _ref_string("version", args)

  _{
    Bucket bucket
    Key key
    BundleType bundle.capitalize
    ETag etag unless etag.empty?
    Version version
  }
end

def _codedeploy_tag_filters(args)
  key = args[:key] || ""
  type = _valid_values(args[:type], %w( key_only value_only key_and_value ), "key_and_value")
  value = args[:value] || ""

  _{
    Key key
    Type type.upcase
    Value value
  }
end
