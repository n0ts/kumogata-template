#
# CloudFront web distribution
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-cloudfront-distribution.html
#
require 'kumogata/template/helper'
require 'kumogata/template/cloudfront'

name = _resource_name(args[:name], "distribution")
config = _cloudfront_distribution_config(args)
depends = _depends([ { function1: 'lambda function' } ], args)
tags = _tags(args)

_(name) do
  Type "AWS::CloudFront::Distribution"
  Properties do
    DistributionConfig config
    Tags tags
  end
  DependsOn depends unless depends.empty?
end
