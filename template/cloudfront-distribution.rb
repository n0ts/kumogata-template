#
# CloudFront web distribution
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-cloudfront-distribution.html
#
require 'kumogata/template/helper'
require 'kumogata/template/cloudfront'

name = _resource_name(args[:name], "distribution")
config = _cloudfront_distribution_config(args)

_(name) do
  Type "AWS::CloudFront::Distribution"
  Properties do
    DistributionConfig config
  end
end
