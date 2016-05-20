#
# output s3
#

bucket = "#{args[:name]} bucket"

_output "#{bucket} s3 domain name", ref_value: [ bucket, "DomainName" ] if args.key? :domain
_output "#{bucket} s3 web site url", ref_value: [ bucket, "WebsiteURL" ]
