require 'abstract_unit'

class EmrStepTest < Minitest::Test
  def test_normal
    template = <<-EOS
_emr_step "test", ref_cluster: "test", jar: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestEmrStep": {
    "Type": "AWS::EMR::Step",
    "Properties": {
      "ActionOnFailure": "CONTINUE",
      "HadoopJarStep": {
        "Jar": "test"
      },
      "JobFlowId": {
        "Ref": "TestEmrCluster"
      },
      "Name": {
        "Fn::Join": [
          "-",
          [
            {
              "Ref": "Service"
            },
            "test"
          ]
        ]
      }
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_aws
    template = <<-EOS
_emr_step "test", ref_cluster: "test", jar: "s3://emr-cfn-test/hadoop-mapreduce-examples-2.6.0.jar", main_class: "pi", args: [ "5", "10" ]
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestEmrStep": {
    "Type": "AWS::EMR::Step",
    "Properties": {
      "ActionOnFailure": "CONTINUE",
      "HadoopJarStep": {
        "Args": [
          "5",
          "10"
        ],
        "Jar": "s3://emr-cfn-test/hadoop-mapreduce-examples-2.6.0.jar",
        "MainClass": "pi"
      },
      "JobFlowId": {
        "Ref": "TestEmrCluster"
      },
      "Name": {
        "Fn::Join": [
          "-",
          [
            {
              "Ref": "Service"
            },
            "test"
          ]
        ]
      }
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
