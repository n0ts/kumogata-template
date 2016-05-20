require 'abstract_unit'

class OutputDynamodbTest < Minitest::Test
  def test_normal
    template = <<-EOS
_output_dynamodb "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestTable": {
    "Description": "description of TestTable",
    "Value": {
      "Ref": "TestTable"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
