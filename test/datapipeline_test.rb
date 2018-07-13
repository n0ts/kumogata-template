require 'abstract_unit'
require 'kumogata/template/datapipeline'

class DatapipelineTest < Minitest::Test
  def test_datapipeline_parameter_objects
    template = <<-EOS
Test _datapipeline_parameter_objects(parameter_objects: [ { test: { attributes: { test: "test" } } } ])
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": [
    {
      "Attributes": [
        {
          "Key": "test",
          "StringValue": "test"
        }
      ],
      "Id": "test"
    }
  ]
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_datapipeline_parameter_objects_attributes
    template = <<-EOS
Test _datapipeline_parameter_objects_attributes(attributes: { test: "test" })

    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": [
    {
      "Key": "test",
      "StringValue": "test"
    }
  ]
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_datapipeline_parameter_values
    template = <<-EOS
Test _datapipeline_parameter_values(parameter_values: { test: "test" })
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": [
    {
      "Id": "test",
      "StringValue": "test"
    }
  ]
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_datapipeline_pipeline_objects
    template = <<-EOS
fields = { test: { ref: "test", string: "test" }, test1: { ref: "test1", string: "test1" } }
Test _datapipeline_pipeline_objects(objects: [ { test: { name: "test", fields: fields } } ])
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": [
    {
      "Fields": [
        {
          "Key": "test",
          "RefValue": "test",
          "StringValue": "test"
        },
        {
          "Key": "test1",
          "RefValue": "test1",
          "StringValue": "test1"
        }
      ],
      "Id": "test",
      "Name": "test"
    }
  ]
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_datapipeline_pipeline_object_fields
    template = <<-EOS
fields = { test: { ref: "test", string: "test" }, test1: {  ref: "test1", string: "test1"} }
Test _datapipeline_pipeline_object_fields(fields: fields)
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": [
    {
      "Key": "test",
      "RefValue": "test",
      "StringValue": "test"
    },
    {
      "Key": "test1",
      "RefValue": "test1",
      "StringValue": "test1"
    }
  ]
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
