require 'abstract_unit'

class CodedeployApplicationTest < Minitest::Test
  def test_normal
    template = <<-EOS
_codedeploy_application "test", application: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestCodedeployApplication": {
    "Type": "AWS::CodeDeploy::Application",
    "Properties": {
      "ApplicationName": "test"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
