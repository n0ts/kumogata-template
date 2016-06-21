#
# Helper - CloudWatch
#

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
