#
# Helper - CloudWatch
#

def _cloudwatch_to_period(value)
  return value if value.nil?
  case value
  when "1m"
    60
  when "5m"
    300
  when "15m"
    900
  when "1h"
    3600
  when "6h"
    21600
  when "1d"
    86400
  else
    value.to_i
  end
end

def _cloudwatch_to_statistic(value)
  return value if value.nil?
  case value.downcase
  when "sample"
    "SampleCount"
  when "avg"
    "Average"
  when "Sum"
    "Sum"
  when "min"
    "Minimum"
  when "max"
    "Maximum"
  else
    value
  end
end

def _cloudwatch_convert_operator(operator)
  case operator
  when ">="
    "GreaterThanOrEqualToThreshold"
  when ">"
    "GreaterThanThreshold"
  when "<="
    "LessThanOrEqualToThreshold"
  when "<"
    "LessThanThreshold"
  else
    _valid_values(operator,
                  %w( GreaterThanOrEqualToThreshold GreaterThanThreshold
                      LessThanOrEqualToThreshold LessThanThreshold ),
                  "GreaterThanThreshold")
  end
end

def _cloudwatch_dimension(args)
  _{
    Name args[:name]
    Value _ref_string("value", args)
  }
end
