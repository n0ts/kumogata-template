#
# CloudFront origin access identity
# https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-cloudfront-cloudfrontoriginaccessidentity.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "origin access identity")
comment = args[:comment] || "access-identity-#{args[:name]}"
depends = _depends([], args)

_(name) do
  Type "AWS::CloudFront::CloudFrontOriginAccessIdentity"
  Properties do
    CloudFrontOriginAccessIdentityConfig _{
      Comment comment
    }
  end
  DependsOn depends unless depends.empty?
end
