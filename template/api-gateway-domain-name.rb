#
# Api Gateway Domain Name
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-apigateway-domainname.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "domain name")
certificate = _ref_string("certificate", args, "certificate")
domain = _ref_string("domain", args, "domain")

_(name) do
  Type "AWS::ApiGateway::DomainName"
  Properties do
    CertificateArn certificate
    DomainName domain
  end
end
