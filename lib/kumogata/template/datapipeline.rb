#
# Helper - DataPipeline
#
require 'kumogata/template/helper'

def _datapipeline_parameter_objects(args)
  (args[:parameter_objects] || []).collect do |object|
    object.collect do |id, value|
      attributes = _datapipeline_parameter_objects_attributes(value)

      _{
        Attributes attributes
        Id id
      }
    end
  end.flatten
end

def _datapipeline_parameter_objects_attributes(args)
  (args[:attributes] || {}).collect do |key, value|
    _{
      Key key
      StringValue value
    }
  end
end

def _datapipeline_parameter_values(args)
  (args[:parameter_values] || {}).collect do |id, value|
    _{
      Id id
      StringValue value
    }
  end
end

def _datapipeline_pipeline_objects(args)
  (args[:objects] || []).collect do |object|
    object.collect do |id, value|
      fields = _datapipeline_pipeline_object_fields(value)
      _{
        Fields fields
        Id id
        Name value[:name]
      }
    end
  end.flatten
end

def _datapipeline_pipeline_object_fields(args)
  (args[:fields] || {}).collect do |key, value|
    _{
      Key key
      RefValue value[:ref] if value.key? :ref
      StringValue value[:string] if value.key? :string
    }
  end
end

