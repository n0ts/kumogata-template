#
# Helper - Redshift
#
require 'kumogata/template/helper'

def _redshift_parameters(args)
  parameters = args[:parameters] || []

  array = []
  parameters.collect do |v|
    name = v[:name] || ""
    value =
      if name == "wlm_json_configuration"
        v[:value].to_json
      else
        v[:value] || ""
      end
    next if name.empty? or value.empty?

    array << _{
      ParameterName name
      ParameterValue value
    }
  end
  array
end
