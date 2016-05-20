#
# RDS instance parameter
#
require 'kumogata/template/helper'

_parameter "#{args[:name]} db instance classes",
           default: args[:instance_class] || RDS_DEFAULT_INSTANCE_CLASS,
           description: "#{args[:name]} db instance classes",
           allowed_values: RDS_INSTANCE_CLASSES
