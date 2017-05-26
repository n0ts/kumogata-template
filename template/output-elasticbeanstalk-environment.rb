#
# Output elasticbeanstalk environment
#
require 'kumogata/template/helper'

_output "#{args[:name]} elasticbeanstalk environment endpoint",
        ref_value: [ "#{args[:name]} elasticbeanstalk environment", "EndpointURL" ],
        export: _export_string(args, "#{args[:name]} elasticbeanstalk environment endpoint")
