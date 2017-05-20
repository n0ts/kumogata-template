#
# Output s3
#
require 'kumogata/template/helper'

bucket = "#{args[:name]} bucket"

_output "#{bucket} s3 domain name", ref_value: [ bucket, "DomainName" ],
                                    export: _export_string(args, "s3 domain name")
_output "#{bucket} s3 web site url", ref_value: [ bucket, "WebsiteURL" ],
                                     export: _export_string(args, "s3 website url")
