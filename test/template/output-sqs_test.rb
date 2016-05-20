require 'abstract_unit'

class OutputSqsTest < Minitest::Test
  def test_normal
    template = <<-EOS
_output_sqs "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestQueue": {
    "Description": "description of TestQueue",
    "Value": {
      "Ref": "TestQueue"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
