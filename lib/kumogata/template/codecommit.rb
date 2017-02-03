#
# Helper - CodeCommit
#
require 'kumogata/template/helper'

def _codecommit_triggers(args)
  triggers = args[:trigger] || []

  array = []
  triggers.each do |trigger|
    array << _{
      Branches trigger[:branchs] || []
      CustomData trigger[:custom] || ""
      DestinationArn trigger[:dest] || ""
      Events trigger[:events] || []
      Name trigger[:name] || ""
    }
  end
  array
end
