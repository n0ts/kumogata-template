#
# Elasticbeanstalk ApplicationVersion resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-beanstalk-version.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "elasticbeanstalk application version")
application = _ref_name("application", args)
description = args[:description] || ""
s3_bucket = _ref_string("s3_bucket", args, "bucket")
s3_key = args[:s3_key]

_(name) do
  Type "AWS::ElasticBeanstalk::ApplicationVersion"
  Properties do
    ApplicationName application
    Description description unless description.empty?
    SourceBundle do
      S3Bucket s3_bucket
      S3Key s3_key
    end
  end
end

