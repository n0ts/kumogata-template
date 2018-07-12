#
# Output s3
#
require 'kumogata/template/helper'

bucket = "#{args[:name]} bucket"

_output "#{bucket} s3 arn",
        ref_value: [ bucket, "Arn" ],
        export: _export_string(args, "s3 arn")
_output "#{bucket} s3 domain name",
        ref_value: [ bucket, "DomainName" ],
        export: _export_string(args, "s3 domain name")
_output "#{bucket} s3 web site url",
        ref_value: [ bucket, "WebsiteURL" ],
        export: _export_string(args, "s3 website url")
_output "#{bucket} s3 dual stack domain name",
        ref_value: [ bucket, "DualStackDomainName" ],
        export: _export(args, "s3 dual stack domain name") if args.key? :ipv6
