#
# Elasticbeanstalk ApplicationVersion resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-beanstalk-version.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "elasticbeanstalk application version")
application = _ref_string_default("application", args,
                                  "elasticbeanstalk application", args[:name])
description = _ref_string_default("description", args, "", "#{args[:name]} elasticbeanstalk application version description")
s3_bucket = _join([
                   _ref_string("s3_bucket", args, "bucket"),
                   _region,
                  ],
                  "-")
s3_key = _ref_string("s3_key", args)

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

