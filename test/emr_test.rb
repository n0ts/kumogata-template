require 'abstract_unit'
require 'kumogata/template/emr'

class EmrTest < Minitest::Test
  def test_emr_to_configurations_default_hadoop_spark
    template = <<-EOS
Test _emr_to_configurations_default_hadoop_spark(max_age: 1)
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": [
    {
      "classification": "hadoop-env",
      "properties": {
      },
      "configurations": [
        {
          "classification": "export",
          "properties": {
            "JAVA_HOME": "/usr/java/default"
          }
        }
      ]
    },
    {
      "classification": "spark-env",
      "properties": {
      },
      "configurations": [
        {
          "classification": "export",
          "properties": {
            "JAVA_HOME": "/usr/java/default"
          }
        }
      ]
    },
    {
      "classification": "spark-defaults",
      "properties": {
        "spark.history.fs.cleaner.enabled": "true",
        "spark.history.fs.cleaner.interval": "1d",
        "spark.history.fs.cleaner.maxAge": "1d"
      }
    }
  ]
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_emr_applications
    template = <<-EOS
Test _emr_applications(applications: [ { name: "test", version: "test" } ])
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": [
    {
      "Name": "Test",
      "Version": "test"
    }
  ]
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_emr_bootstraps
    template = <<-EOS
Test _emr_bootstraps(bootstraps: [ { name: "test", script_path: "test" } ])
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": [
    {
      "Name": "test",
      "ScriptBootstrapAction": {
        "Path": "test"
      }
    }
  ]
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_emr_configurations
    template = <<-EOS
configuration = {
  classification: "test",
  properties: {},
  configurations: [
    classification: "export",
    properties: { JAVA_HOME: "/usr/java/default" },
  ],
}
Test _emr_configurations(configurations: [ configuration ] )
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": [
    {
      "Classification": "test",
      "ConfigurationProperties": {
      },
      "Configurations": [
        {
          "Classification": "export",
          "ConfigurationProperties": {
            "JAVA_HOME": "/usr/java/default"
          },
          "Configurations": [

          ]
        }
      ]
    }
  ]
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_emr_ebs
    template = <<-EOS
Test _emr_ebs(ebs: [ { size: "test" } ])
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "EbsBlockDeviceConfig": [
      {
        "VolumeSpecification": {
          "SizeInGB": "test",
          "VolumeType": "gp2"
        }
      }
    ]
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_emr_ebs_block_device
    template = <<-EOS
Test _emr_ebs_block_device({ size: "test" })
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "VolumeSpecification": {
      "SizeInGB": "test",
      "VolumeType": "gp2"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_emr_ebs_volume
    template = <<-EOS
Test _emr_ebs_volume({ size: "test" })
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "SizeInGB": "test",
    "VolumeType": "gp2"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_emr_job_flow
    template = <<-EOS
Test _emr_job_flow(job: { core: { name: "test" }, master: { name: "test" } })
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
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
  }
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
Test _emr_job_flow(job: { core: { fleet: { name: "test", configs: [ { bid: 1 } ], on_demand: 1, spot: 2 } },
                          master: { fleet: { name: "test", configs: [ { bid: 1 } ], on_demand: 1, spot: 2  } } } )
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "CoreInstanceFleet": {
      "InstanceTypeConfigs": [
        {
          "BidPrice": "1",
          "InstanceType": "c4.large",
          "WeightedCapacity": "1"
        }
      ],
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
      "TargetOnDemandCapacity": "1",
      "TargetSpotCapacity": "2"
    },
    "MasterInstanceFleet": {
      "InstanceTypeConfigs": [
        {
          "BidPrice": "1",
          "InstanceType": "c4.large",
          "WeightedCapacity": "1"
        }
      ],
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
      "TargetOnDemandCapacity": "1",
      "TargetSpotCapacity": "2"
    },
    "TerminationProtected": "false"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_emr_instance_group
    template = <<-EOS
Test _emr_instance_group({ name: "test" })
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "InstanceCount": "1",
    "InstanceType": "c4.large",
    "Market": "ON_DEMAND",
    "Name": "test"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_emr_hadoop_jar_step_config
    template = <<-EOS
Test _emr_hadoop_jar_step_config(jar: "test")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Jar": "test"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_emr_instance_autoscaling
    template = <<-EOS
autoscaling = {
  max: 1,
  min: 0,
  rules: [
    { rule: "test1", type: "change", cool: 60, scaling: 1, operator: ">=", definition: "test2", threshold: 60, unit: "sec" },
  ],
}
Test _emr_instance_autoscaling({ autoscaling: autoscaling })
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Constraints": {
      "MaxCapacity": "1",
      "MinCapacity": "0"
    },
    "Rules": [
      {
        "Action": {
          "Market": "ON_DEMAND",
          "SimpleScalingPolicyConfiguration": {
            "AdjustmentType": "CHANGE_IN_CAPACITY",
            "CoolDown": "60",
            "ScalingAdjustment": "1"
          }
        },
        "Description": "test1 instance autoscaling rules description",
        "Name": "test1",
        "Trigger": {
          "CloudWatchAlarmDefinition": {
            "ComparisonOperator": "GREATER_THAN_OR_EQUAL",
            "EvaluationPeriods": "1",
            "MetricName": "test2",
            "Namespace": "AWS/ElasticMapReduce",
            "Period": "300",
            "Statistic": "AVERAGE",
            "Threshold": "60",
            "Unit": "Seconds"
          }
        }
      }
    ]
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
