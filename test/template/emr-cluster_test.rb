require 'abstract_unit'

class EmrClusterTest < Minitest::Test
  def test_normal
    template = <<-EOS
_emr_cluster "test", job: { core: { name: "test" }, master: { name: "test" } }
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestEmrCluster": {
    "Type": "AWS::EMR::Cluster",
    "Properties": {
      "Instances": {
        "CoreInstanceGroup": {
          "InstanceCount": "1",
          "InstanceType": "c4.large",
          "Market": "ON_DEMAND",
          "Name": "test"
        },
        "MasterInstanceGroup": {
          "InstanceCount": "1",
          "InstanceType": "c4.large",
          "Market": "ON_DEMAND",
          "Name": "test"
        },
        "TerminationProtected": "false"
      },
      "JobFlowRole": "EMR_EC2_DefaultRole",
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
      },
      "ReleaseLabel": "emr-4.6.0",
      "ServiceRole": "EMR_DefaultRole",
      "Tags": [
        {
          "Key": "Name",
          "Value": {
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
      ],
      "VisibleToAllUsers": "false"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_aws
    template = <<-EOS
core = { name: "Core", count: 1, instance_type: "m3.xlarge" }
master = { name: "Master", count: 1, instance_type: "m3.xlarge" }
_emr_cluster "test", job: { core: core, master: master, termination: true }, cluster: "TestCluster"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestEmrCluster": {
    "Type": "AWS::EMR::Cluster",
    "Properties": {
      "Instances": {
        "CoreInstanceGroup": {
          "InstanceCount": "1",
          "InstanceType": "m3.xlarge",
          "Market": "ON_DEMAND",
          "Name": "Core"
        },
        "MasterInstanceGroup": {
          "InstanceCount": "1",
          "InstanceType": "m3.xlarge",
          "Market": "ON_DEMAND",
          "Name": "Master"
        },
        "TerminationProtected": "true"
      },
      "JobFlowRole": "EMR_EC2_DefaultRole",
      "Name": "TestCluster",
      "ReleaseLabel": "emr-4.6.0",
      "ServiceRole": "EMR_DefaultRole",
      "Tags": [
        {
          "Key": "Name",
          "Value": "TestCluster"
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
      ],
      "VisibleToAllUsers": "false"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
