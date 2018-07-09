require 'abstract_unit'

class EmrInstanceGroupTest < Minitest::Test
  def test_normal
    template = <<-EOS
_emr_instance_group_config "test", ref_cluster: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestEmrInstanceGroupConfig": {
    "Type": "AWS::EMR::InstanceGroupConfig",
    "Properties": {
      "InstanceCount": "1",
      "InstanceRole": "TASK",
      "InstanceType": "#{EMR_DEFAULT_INSTANCE_TYPE}",
      "JobFlowId": {
        "Ref": "TestEmrCluster"
      },
      "Market": "ON_DEMAND",
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
_emr_instance_group_config "test", ref_cluster: "cluster", instance_count: 2, instance_type: "m3.xlarge", instance_role: "TASK", config: "cfnTask2"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestEmrInstanceGroupConfig": {
    "Type": "AWS::EMR::InstanceGroupConfig",
    "Properties": {
      "InstanceCount": "2",
      "InstanceRole": "TASK",
      "InstanceType": "m3.xlarge",
      "JobFlowId": {
        "Ref": "ClusterEmrCluster"
      },
      "Market": "ON_DEMAND",
      "Name": "cfnTask2"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
