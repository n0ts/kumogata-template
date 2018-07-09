#
# Helper - Logs
#
require 'kumogata/template/helper'

def _logs_metric_filter_transformations(args)
  (args[:transformations] || []).collect do |tran|
    _{
      MetricName tran[:name]
      MetricNamespace tran[:ns]
      MetricValue tran[:value]
    }
  end
end
