#
# Helper - Events
#
require 'kumogata/template/helper'

def _events_pattern(args)
  pattern = args[:pattern] || ""
  return "" if pattern.empty?

end

def _events_targets(args)
  targets = args[:targets] || []

  array = []
  targets.each do |target|
    array << _{
      Arn target[:arn]
      Id target[:id]
      Input target[:input] if target.key? :input
      InputPath target[:path] if target.key? :path
    }
  end
  array
end
