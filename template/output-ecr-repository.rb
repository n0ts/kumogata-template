#
# Output ecr repository
#
require 'kumogata/template/helper'

_output "#{args[:name]} ecr repository",
        ref_value: "#{args[:name]} ecr repository",
        export: _export_string(args, "ecr repository")
_output "#{args[:name]} ecr repository uri",
         value: _join([ _account_id,
                        ".dkr.ecr.",
                        _region,
                        ".amazonaws.com/",
                        _ref(_resource_name("#{args[:name]} ecr repository")),
                      ], ""),
         export: _export_string(args, "ecr repository uri")
