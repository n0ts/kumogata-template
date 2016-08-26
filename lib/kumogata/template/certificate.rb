#
# Helper - Certificate
#
require 'kumogata/template/helper'

def _certificate_validations(args)
  validation = args[:validation] || []
  validation << { domain: args[:domain], validation: args[:domain] } if validation.empty?

  result = []
  validation.each do |val|
    result << _{
      DomainName val[:domain]
      ValidationDomain val[:validation]
    }
  end
  result
end
