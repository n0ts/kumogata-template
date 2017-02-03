require 'abstract_unit'
require 'kumogata/template/codebuild'

class CodebuildTest < Minitest::Test
  def test_codebuild_artifacts
    template = <<-EOS
Test _codebuild_artifacts({})
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Type": "no_artifacts"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_codebuild_environment
    template = <<-EOS
Test _codebuild_environement({ compute: "large", env: { test: "test" }, image: "test" })
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "ComputeType": "BUILD_GENERAL1_LARGE",
    "EnvironmentVariables": [
      {
        "Name": "test",
        "Value": "test"
      }
    ],
    "Image": "test",
    "Type": "LINUX_CONTAINER"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_codebuild_environment_hash
    template = <<-EOS
Test _codebuild_environement_hash({ test: "test" })
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": [
    {
      "Name": "test",
      "Value": "test"
    }
  ]
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_codebuild_source
    template = <<-EOS
Test _codebuild_source({ type: "github", location: "test" })
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Location": "test",
    "Type": "GITHUB"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
