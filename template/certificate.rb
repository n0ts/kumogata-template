#
# CertificateManager Certificate resource
# https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-certificatemanager-certificate.html
#
require 'kumogata/template/helper'
require 'kumogata/template/certificate'

name = _resource_name(args[:name], "certificate")
domain = _ref_string("domain", args, "domain")
validation = _certificate_validations(args)
subject = _ref_array("subject", args)

_(name) do
  Type "AWS::CertificateManager::Certificate"
  Properties do
    DomainName domain
    DomainValidationOptions validation
    SubjectAlternativeNames subject unless subject.empty?
  end
end
