require 'abstract_unit'

class OutputStageTest < Minitest::Test
  def test_normal
    template = <<-EOS
_output_stage "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestStage": {
    "Description": "description of TestStage",
    "Value": {
      "Ref": "TestStage"
    }
  },
  "TestStageInvokeUrl": {
    "Description": "description of TestStageInvokeUrl",
    "Value": {
      "Fn::Join": [
        "",
        [
          "https://",
          {
            "Ref": "TestRestApi"
          },
          ".execute-api.",
          {
            "Ref": "AWS::Region"
          },
          ".amazonaws.com/",
          {
            "Ref": "TestStage"
          }
        ]
      ]
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
