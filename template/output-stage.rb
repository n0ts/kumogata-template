#
# Output stage
#

require 'kumogata/template/helper'

_output "#{args[:name]} stage",
        ref_value: "#{args[:name]} stage",
        export: _export_string(args, "stage")

url = _join([ "https://",
              _ref_string("", { ref_: "#{args[:name]} rest api" }),
              ".execute-api.",
              _region,
              ".amazonaws.com/",
              _ref_string("", { ref_: "#{args[:name]} stage" }) ], "")
_output "#{args[:name]} stage invoke url",
        value: url,
        export: _export_string(args, "stage invoke url")
