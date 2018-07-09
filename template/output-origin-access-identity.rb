#
# Output origin access identity
#
require 'kumogata/template/helper'

origin = "#{args[:name]} origin access identity"

_output origin,
        ref_value: origin,
        export: _export_string(args, "origin access identity")
_output "#{origin} s3 canonical user id",
        ref_value: [ origin, "S3CanonicalUserId" ],
        export: _export_string(args, "origin access identity s3 canonical user id")
