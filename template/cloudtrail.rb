#
# Cloudtrail Trail resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-cloudtrail-trail.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "trail")
depends = args[:depends] || []
group = _ref_attr_string("group", "Arn", args)
role = _ref_attr_string("role", "Arn", args)
enable = _bool("enable", args, false)
include = _bool("include", args, false)
logging = _bool("logging", args, true)
multiRegionTrail = _bool("multiRegionTrail", args, false)
s3_bucket = _ref_string("s3_bucket", args, "bucket")
s3_key = _ref_string("s3_key", args, "key")
sns =
  if args.key? :sns
    _attr_string(_resource_name(args[:ref_sns], "sns"), "TopicName")
  else
    ""
  end
tags = _tags(args)

_(name) do
  DependsOn depends unless depends.empty?
  Type "AWS::CloudTrail::Trail"
  Properties do
    CloudWatchLogsLogGroupArn group unless group.empty?
    CloudWatchLogsRoleArn role unless role.empty?
    EnableLogFileValidation enable
    IncludeGlobalServiceEvents include
    IsLogging logging
    IsMultiRegionTrail multiRegionTrail
    #KMSkeyId
    S3BucketName s3_bucket
    S3KeyPrefix s3_key unless s3_key.empty?
    SnsTopicName sns unless sns.empty?
    Tags tags unless tags.empty?
  end
end
