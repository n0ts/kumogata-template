#
# Datapipeline pipeline resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-datapipeline-pipeline.html
#
require 'kumogata/template/helper'
require 'kumogata/template/datapipeline'

name = _resource_name(args[:name], "pipeline")
active = _bool("active", args, true)
description = _ref_string_default("description", args, '', "#{args[:name]} pipeline description")
pipeline = _name("pipeline", args)
parameter_objects = _datapipeline_parameter_objects(args)
parameter_values = _datapipeline_parameter_values(args)
pipeline_objects = _datapipeline_pipeline_objects(args)
pipeline_tags = _tags(args, "pipeline")

_(name) do
  Type "AWS::DataPipeline::Pipeline"
  Properties do
    Activate active
    Description description unless description.empty?
    Name pipeline
    ParameterObjects parameter_objects unless parameter_objects.empty?
    ParameterValues parameter_values unless parameter_values.empty?
    PipelineObjects pipeline_objects
    PipelineTags pipeline_tags unless pipeline_tags.empty?
  end
end
