#
# Output rest api
#
require 'kumogata/template/helper'

_output "#{args[:name]} rest api",
        ref_value: "#{args[:name]} rest api",
        export: _export_string(args, "rest api")
_output "#{args[:name]} rest api root resource",
        ref_value: [ "#{args[:name]} rest api", "RootResourceId" ],
        export: _export_string(args, "rest api root resource")
