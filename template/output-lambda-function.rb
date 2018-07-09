#
# Output lambda function
#
require 'kumogata/template/helper'

_output_arn "#{args[:name]} lambda function", export: args[:export] || false
