#
# Helper - Logs
#
require 'kumogata/template/helper'

def _logs_metric_filter_transformations(args)
  trans = args[:transformations] || []

  array = []
  trans.each do |tran|
    array << _{
      MetricName tran[:name]
      MetricNamespace tran[:ns]
      MetricValue tran[:value]
    }
  end
  array
end
