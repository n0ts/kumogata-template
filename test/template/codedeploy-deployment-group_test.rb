require 'abstract_unit'

class CodedeployDeploymentGroupTest < Minitest::Test
  def test_normal
    template = <<-EOS
deployment = { description: "test", revision: { s3: { bucket: "test", key: "test", version: "test" } } }
_codedeploy_deployment_group "test", ref_application: "test",
                                     ref_autoscalings: %w( test ),
                                     deployment: deployment,
                                     ref_service: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestDeploymentGroup": {
    "Type": "AWS::CodeDeploy::DeploymentGroup",
    "Properties": {
      "ApplicationName": {
        "Ref": "TestCodedeployApplication"
      },
      "AutoScalingGroups": [
        {
          "Ref": "TestAutoscalingGroup"
        }
      ],
      "Deployment": {
        "Description": "test",
        "IgnoreApplicationStopFailures": "true",
        "Revision": {
          "RevisionType": "S3",
          "S3Location": {
            "Bucket": "test",
            "Key": "test",
            "BundleType": "Zip",
            "Version": "test"
          }
        }
      },
      "ServiceRoleArn": {
        "Ref": "TestServiceRole"
      }
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
