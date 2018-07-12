#
# Helper - Certificate
#
require 'kumogata/template/helper'

def _certificate_validations(args)
  validations = args[:validation] || []
  return [ _{
             DomainName _ref_string("domain", args, "domain")
             ValidationDomain _ref_string("domain", args, "domain")
           } ] if validations.empty?

  validations.collect do |validation|
    domain = _ref_string("domain", validation, "domain")
    validation = _ref_string("validation", validation, "domain")
    _{
      DomainName domain
      ValidationDomain validation || domain
    }
  end
end
