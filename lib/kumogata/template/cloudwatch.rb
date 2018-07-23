#
# Helper - CloudWatch
#
require 'kumogata/template/helper'

def _cloudwatch_to_period(value)
  return value if value.nil?
  case value
  when "1m"
    60
  when "5m"
    300
  when "15m"
    900
  when "1h"
    3600
  when "6h"
    21600
  when "1d"
    86400
  else
    value.to_i
  end
end

def _cloudwatch_to_statistic(value)
  return value if value.nil?
  case value.downcase
  when "sample"
    "SampleCount"
  when "avg"
    "Average"
  when "Sum"
    "Sum"
  when "min"
    "Minimum"
  when "max"
    "Maximum"
  else
    value
  end
end

def _cloudwatch_to_metric(value)
  prefix = $1 if value =~ /^(\w+) /
  # http://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CW_Support_For_AWS.html
  case prefix
  when "ec2", "ec2 spot", "ecs", "eb", "ebs", "efs", "elb", "alb", "emr", "es",
    "transcoder", "iot",
    "kinesis firehose", "firehose", "kinesis", "kms",
    "lambda", "ml",
    "ops works", "ow",
    "polly",
    "redshift",
    "rds", "route53",
    "ses", "sns", "sqs", "s3", "swf", "storage", "storage gateway",
    "waf", "work spaces", "ws"
    value.slice!(/^#{prefix} /)
    value = value.split(" ").collect! do |v|
      case v
      when "cpu", "iops"
        v.upcase
      else
        v.capitalize
      end
    end.join("")
  end
  value
end

def _cloudwatch_to_namespace(value)
  return value if value.include? "/"
  # http://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/aws-namespaces.html
  value =
    case value
    when "api gateway"
      "ApiGateway"
    when "auto scaling"
      "AutoScaling"
    when "billing"
      "Billing"
    when "cloud front"
      "CloudFront"
    when "cloud search"
      "CloudSearch"
    when "cloudwatch events"
      "Events"
    when "cloudwatch logs"
      "Logs"
    when "dynamodb", "dynamod db"
      "DynamoDB"
    when "ec2"
      "EC2"
    when "ec2 spot"
      "EC2Spot"
    when "ecs"
      "ECS"
    when "eb"
      "ElasticBeanstalk"
    when "ebs"
      "EBS"
    when "efs"
      "EFS"
    when "elb"
      "ELB"
    when "alb"
      "ApplicationELB"
    when "transcoder"
      "ElasticTranscoder"
    when "elasti cache", "cache"
      "ElastiCache"
    when "es"
      "ES"
    when "emr"
      "ElasticMapReduce"
    when "iot"
      "IoT"
    when "kms"
      "KMS"
    when "kinesis analytics"
      "KinesisAnalytics"
    when "kinesis firehose", "firehose"
      "Firehose"
    when "kinesis"
      "Kinesis"
    when "lambda"
      "Lambda"
    when "ml"
      "ML"
    when "ops works", "ow"
      "OpsWorks"
    when "polly"
      "Polly"
    when "redshift"
      "Redshift"
    when "rds"
      "RDS"
    when "route53"
      "Route53"
    when "ses"
      "SES"
    when "sns"
      "SNS"
    when "sqs"
      "SQS"
    when "s3"
      "S3"
    when "swf"
      "SWF"
    when "storage", "storage gateway"
      "StorageGateway"
    when "waf"
      "WAF"
    when "work spaces", "ws"
      "WorkSpaces"
  end
  "AWS/#{value}"
end

def _cloudwatch_to_operator(value)
  case value
  when ">="
    "GreaterThanOrEqualToThreshold"
  when ">"
    "GreaterThanThreshold"
  when "<="
    "LessThanOrEqualToThreshold"
  when "<"
    "LessThanThreshold"
  else
    _valid_values(value,
                  %w( GreaterThanOrEqualToThreshold GreaterThanThreshold
                      LessThanOrEqualToThreshold LessThanThreshold ),
                  "GreaterThanThreshold")
  end
end

def _cloudwatch_to_unit(value)
  case value
  when "sec"
    "Seconds"
  when "ms"
    "Microseconds"
  when "mms"
    "Milliseconds"
  when "B"
    "Bytes"
  when "KB"
    "Kilobytes"
  when "MB"
    "Megabytes"
  when "GB"
    "Gigabytes"
  when "TB"
    "Terabytes"
  when "b"
    "Bits"
  when "kb", "Kb"
    "Kilobits"
  when "mb", "Mb"
    "Megabits"
  when "gb", "Gb"
    "Gigabits"
  when "tb", "Tb"
    "Terabits"
  when "%", "percent"
    "Percent"
  when "count"
    "Count"
  when "B/s"
    "Bytes/Second"
  when "KB/s"
    "Kilobytes/Second"
  when "MB/s"
    "Megabytes/Second"
  when "GB/s"
    "Gigabyes/Second"
  when "TB/s"
    "Terabytes/Second"
  when "bps"
    "Bits/Second"
  when "kbps"
    "Kilobits/Second"
  when "mbps"
    "Megabits/Second"
  when "gbps"
    "Gigabits/Second"
  when "tbps"
    "Terabits/Second"
  when "cps"
    "Count/Second"
  else
    _valid_values(value,
                  %w(Seconds Microseconds Milliseconds Bytes Kilobytes Megabytes Gigabytes Terabytes Bits Kilobits Megabits Gigabits Terabits Percent Count Bytes/Second Kilobytes/Second Megabytes/Second Gigabytes/Second Terabytes/Second Bits/Second Kilobits/Second Megabits/Second Gigabits/Second Terabits/Second Count/Second None),
                  "")
  end
end

def _cloudwatch_to_ec2_action(value)
  value = _valid_values(value, %w( recover stop terminate reboot ), "recover")
  _join([ "arn:aws:automate:", _region, ":ec2:#{value}" ], "")
end

def _cloudwatch_dimension(args)
  _{
    Name args[:name]
    Value _ref_string("value", args)
  }
end

def _cloudwatch_actions(args)
  (args[:actions] || args[:ref_actions] || []).collect do |action|
    if action =~ /ec2 (\w)/
      _cloudwatch_to_ec2_action($1)
    else
      if args.key? :ref_actions
        _ref_string("action", { ref_action: action })
      else
        action
      end
    end
  end
end
