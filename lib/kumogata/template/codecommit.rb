#
# Helper - CodeCommit
#
require 'kumogata/template/helper'

def _codecommit_triggers(args)
  (args[:trigger] || []).each do |trigger|
    _{
      Branches trigger[:branchs] || []
      CustomData trigger[:custom] || ""
      DestinationArn trigger[:dest] || ""
      Events trigger[:events] || []
      Name trigger[:name] || ""
    }
  end
end
