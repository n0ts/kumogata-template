#
# Helper - CloudWatch
#

def _cloudwatch_convert_operator(operator)
  case operator
  when ">="
    "GreaterThanOrEqualToThreshold"
  when ">"
    "GreaterThanThreshold"
  when "<="
    "LessThanThreshold"
  when "<"
    "LessThanOrEqualToThreshold"
  else
    _valid_values(operator,
                  %w( GreaterThanOrEqualToThreshold GreaterThanThreshold
                      LessThanThreshold LessThanOrEqualToThreshold ),
                  "GreaterThanThreshold")
  end
end

def _cloudwatch_dimension(args)
  _{
    Name args[:name]
    Value _ref_string("value", args)
  }
end
