require 'abstract_unit'

class CodebuildProjectTest < Minitest::Test
  def test_normal
    template = <<-EOS
_codebuild_project "test", { artifacts: { type: "test" },
                             environment: { compute: "large", image: "test", env: { "test": "test" } },
                             project: "test",
                             service: "test",
                             source: { type: "github" } }
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestCodebuildProject": {
    "Type": "AWS::CodeBuild::Project",
    "Properties": {
      "Artifacts": {
        "Type": "no_artifacts"
      },
      "Description": "test codebuild project description",
      "Environment": {
        "ComputeType": "BUILD_GENERAL1_LARGE",
        "EnvironmentVariables": [
          {
            "Name": "test",
            "Value": "test"
          }
        ],
        "Image": "test",
        "Type": "LINUX_CONTAINER"
      },
      "Name": "test",
      "ServiceRole": "test",
      "Source": {
        "Location": "",
        "Type": "GITHUB"
      },
      "Tags": [
        {
          "Key": "Name",
          "Value": "test"
        },
        {
          "Key": "Service",
          "Value": {
            "Ref": "Service"
          }
        },
        {
          "Key": "Version",
          "Value": {
            "Ref": "Version"
          }
        }
      ]
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
