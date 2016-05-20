#
# Helper - DataPipeline
#
require 'kumogata/template/helper'

def _datapipeline_parameter_objects(args)
  objects = args[:parameter_objects] || []

  array = []
  objects.each do |object|
    object.each do |id, value|
      attributes = _datapipeline_parameter_objects_attributes(value)
      array << _{
        Attributes attributes
        Id id
      }
    end
  end
  array
end

def _datapipeline_parameter_objects_attributes(args)
  attributes = args[:attributes] || {}

  array = []
  attributes.each do |key, value|
    array << _{
      Key key
      StringValue value
    }
  end
  array
end

def _datapipeline_parameter_values(args)
  values = args[:parameter_values] || {}

  array = []
  values.each do |id, val|
    array << _{
      Id id
      StringValue val
    }
  end
  array
end

def _datapipeline_pipeline_objects(args)
  objects = args[:objects] || []

  array = []
  objects.each do |object|
    object.each do |id, value|
      fields = _datapipeline_pipeline_object_fields(value)
      array << _{
        Fields fields
        Id id
        Name value[:name]
      }
    end
  end
  array
end

def _datapipeline_pipeline_object_fields(args)
  fields = args[:fields] || {}

  array = []
  fields.each do |key, value|
    array << _{
      Key key
      RefValue value[:ref] if value.key? :ref
      StringValue value[:string] if value.key? :string
    }
  end
  array
end

def _datapipeline_pipeline_tags(args)
  tags = args[:tags] || {}

  array = []
  tags.each do |key, value|
    array << _{
      Key key
      Value value
    }
  end
  array
end
