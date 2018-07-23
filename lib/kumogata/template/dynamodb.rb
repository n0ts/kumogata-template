#
# Helper - DynamoDB
#
require 'kumogata/template/helper'

def _dynamodb_attribute(args)
  attributes = []
  _array(args).each do |arg|
    if arg.is_a? String
      attributes << { type: "string", value: arg }
    elsif arg.is_a? Hash
      arg.each_pair.collect{|type, value| attributes << { type: type, value: value } }
    end
  end

  attributes.collect do |attribute|
    type =
      case attribute[:type].to_sym
      when :binary
        "B"
      when :integer
        "N"
      else
        "S"
      end
    _{
      AttributeName attribute[:value]
      AttributeType type
    }
  end
end

def _dynamodb_key_schema(args)
  schemas = []
  _array(args).each do |arg|
    if arg.is_a? String
      schemas << { type: "hash", value: arg }
    elsif arg.is_a? Hash
      arg.each_pair.collect{|type, value| schemas << { type: type, value: value } }
    end
  end

  schemas.collect do |schema|
    type =
      case schema[:type].to_sym
      when :range
        "range"
      else
        "hash"
      end
    _{
      AttributeName schema[:value]
      KeyType type.upcase
    }
  end
end

def _dynamodb_projection(args)
  non_key = args[:non_key] || []
  type = _valid_values(args[:type], %w( keys_only include all ), "include")

  _{
    NonKeyAttributes non_key unless non_key.empty?
    ProjectionType type.upcase unless type.empty?
  }
end

def _dynamodb_provisioned(args)
  _{
    ReadCapacityUnits args[:read] || 5
    WriteCapacityUnits args[:write] || args[:read] || 5
  }
end

def _dynamodb_stream(args)
  stream = args[:stream] || ""

  _{
    StreamViewType stream
  }
end

def _dynamodb_global(args)
  index = args[:index]
  key_schema = _dynamodb_key_schema(args[:key_schema])
  projection = _dynamodb_projection(args[:projection])
  provisioned = _dynamodb_provisioned(args[:provisioned])

  _{
    IndexName index
    KeySchema key_schema
    Projection projection
    ProvisionedThroughput provisioned
  }
end

def _dynamodb_local(args)
  index = args[:index]
  key_schema = _dynamodb_key_schema(args[:key_schema])
  projection = _dynamodb_projection(args[:projection])

  _{
    IndexName index
    KeySchema key_schema
    Projection projection
  }
end

def _dynamodb_ttl(args)
  ttl = args[:ttl] || {}
  return ttl if ttl.empty?

  attr = args[:attr] || ""
  enabled = _bool("enabled", args, true)

  _{
    AttributeName attr unless attr.empty?
    Enabled enabled
  }
end
