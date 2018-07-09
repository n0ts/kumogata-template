#
# Helper - EMR
#
require 'kumogata/template/helper'
require 'kumogata/template/cloudwatch'

def _emr_to_configurations_default_hadoop_spark(max_age: 14)
  _emr_to_configurations_default_hadoop | _emr_to_configurations_default_spark(max_age: max_age)
end

def _emr_to_configurations_default_hadoop()
  [
   {
     classification: "hadoop-env",
     properties: {},
     configurations: [
                      classification: "export",
                      properties: { JAVA_HOME: "/usr/java/default" },
                     ],
   }
  ]
end

def _emr_to_configurations_default_spark(max_age: 14)
  [
   {
     classification: "spark-env",
     properties: {},
     configurations: [
                      classification: "export",
                      properties: { JAVA_HOME: "/usr/java/default" },
                     ],
   },
   {
     classification: "spark-defaults",
     properties: {
       "spark.history.fs.cleaner.enabled"  => "true",
       "spark.history.fs.cleaner.interval" => "1d",
       "spark.history.fs.cleaner.maxAge"  => "#{max_age}d",
     }
   }
  ]
end

def _emr_applications(args)
  applications = args[:applications] || []

  applications.collect do |application|
    args = application[:args] || []
    _{
      #AdditionalInfo
      Args args unless args.empty?
      Name application[:name].capitalize
      Version application[:version] if application.key? :version
    }
  end
end

def _emr_bootstraps(args)
  actions = args[:bootstraps] || []

  actions.collect do |action|
    _{
      Name action[:name]
      ScriptBootstrapAction _{
        Args action[:script_args] if action.key? :script_args
        Path action[:script_path]
      }
    }
  end
end

def _emr_configurations(args)
  configurations = args[:configurations] || []

  configurations.collect do |configuration|
    classification = configuration[:classification] || ""
    properties = configuration[:properties] || {}
    configurations = _emr_configurations(configuration)
    _{
      Classification classification unless classification.empty?
      ConfigurationProperties properties
      Configurations configurations
    }
  end
end

def _emr_ebs(args)
  ebs = args[:ebs] || []
  return '' if ebs.empty?
  block_devices = ebs.collect{|v| _emr_ebs_block_device(v) }

  _{
    EbsBlockDeviceConfig block_devices
    EbsOptimized true if args.key? :ebs_optimized
  }
end

def _emr_ebs_block_device(args)
  volume_spec = _emr_ebs_volume(args)
  volume_per_instance = args[:per_instance] || ""

  _{
    VolumeSpecification volume_spec
    VolumesPerInstance volume_per_instance unless volume_per_instance.empty?
  }
end

def _emr_ebs_volume(args)
  iops = args[:iops] || 300
  size = _ref_string("size", args, "volume size")
  type = _valid_values(args[:type], %w( io1 gp2 sc1 st1 ), "gp2")

  _{
    Iops iops if type == "io1"
    SizeInGB size
    VolumeType type
  }
end

def _emr_job_flow(args)
  job = args[:job] || {}

  add_master_security_groups = _ref_array("add_master_security_groups", job, "security group")
  add_slave_security_groups = _ref_array("add_slave_security_groups", job, "security group")
  core_instance_fleet = _emr_instance_fleet(job[:core])
  core_instance_group = _emr_instance_group(job[:core])
  key_name = _ref_string("key_name", job, "key name")
  subnet = _ref_string("subnet", job, "subnet")
  emr_master_security_group = _ref_string("emr_master_security_group", job, "security group")
  emr_slave_security_group = _ref_string("emr_slave_security_group", job, "security group")
  hadoop_version = _valid_values("hadoop", %w( 1.0.3 2.2.0 2.4.0 ))
  master_instance_fleet = _emr_instance_fleet(job[:master])
  master_instance_group = _emr_instance_group(job[:master])
  placement = job[:placement] || ""
  service_access_security_group = _ref_string("service_access_security_group", job, "security group")
  termination = _bool("termination", job, false)

  _{
    AdditionalMasterSecurityGroups add_master_security_groups unless add_master_security_groups.empty?
    AdditionalSlaveSecurityGroups add_slave_security_groups unless add_slave_security_groups.empty?
    CoreInstanceFleet core_instance_fleet unless core_instance_fleet.empty?
    CoreInstanceGroup core_instance_group if core_instance_fleet.empty?
    Ec2KeyName key_name unless key_name.empty?
    Ec2SubnetId subnet unless subnet.empty?
    EmrManagedMasterSecurityGroup emr_master_security_group unless emr_master_security_group.empty?
    EmrManagedSlaveSecurityGroup emr_slave_security_group unless emr_slave_security_group.empty?
    HadoopVersion hadoop_version unless hadoop_version.nil?
    MasterInstanceFleet master_instance_fleet unless master_instance_fleet.empty?
    MasterInstanceGroup master_instance_group if master_instance_fleet.empty?
    Placement _{
      AvailabilityZone placement
    } unless placement.empty?
    ServiceAccessSecurityGroup service_access_security_group unless service_access_security_group.empty?
    TerminationProtected termination
  }
end

def _emr_instance_fleet(args)
  fleet = args[:fleet] || ""
  return fleet if fleet.empty?

  configs = _emr_instance_fleet_type_config(fleet)
  launch = _emr_instance_fleet_launch(fleet)
  name = _name("fleet", fleet)
  on_demand = fleet[:on_demand] || 1
  spot = fleet[:spot] || 1

  _{
    InstanceTypeConfigs configs
    LaunchSpecifications do
      SpotSpecification launch
    end unless launch.empty?
    Name name
    TargetOnDemandCapacity on_demand
    TargetSpotCapacity spot
  }
end

def _emr_instance_fleet_type_config(args)
  (args[:configs] || []).collect do |config|
    bid = config[:bid] || 0
    bid_percent = config[:bid_percent] || ""
    configurations = _emr_configurations(config)
    ebs = _emr_ebs(config)
    instance_type = _ref_string_default("instance_type", args, "instance type", EMR_DEFAULT_INSTANCE_TYPE)
    weighted = config[:weighted] || 1

    _{
      BidPrice bid if 0 < bid
      BidPriceAsPercentageOfOnDemandPrice bid_percent unless bid_percent.empty?
      Configurations configurations unless configurations.empty?
      EbsConfiguration ebs unless ebs.empty?
      InstanceType instance_type
      WeightedCapacity weighted
    }
  end
end

def _emr_instance_fleet_launch(args)
  launch = args[:launch] || ""
  return launch if launch.empty?

  block = _valid_values(launch[:block], %w( 60 120 180 240 300 360 ), "")
  timeout_action =
    case launch[:timeout_action]
    when "switch"
      "SWITCH_TO_ON_DEMAND"
    when "terminate"
      "TERMINATE_CLUSTER"
    else
      "SWITCH_TO_ON_DEMAND"
    end
  timeout_duration = launch[:timeout_duration] || 5

  _{
    BlockDurationMinutes block unless block.empty?
    TimeoutAction timeout_action.upcase
    TimeoutDurationMinutes timeout_duration
  }
end

def _emr_instance_group(args)
  bid = args[:bid] || ""
  configurations = _emr_configurations(args)
  instance_count = args[:instance_count] || 1
  instance_type = _ref_string_default("instance_type", args, "instance type", EMR_DEFAULT_INSTANCE_TYPE)
  market = _valid_values("market", %w( on_demand, spot), "on_demand")
  name = _ref_string("name", args)

  _{
    BidPrice bid unless bid.empty?
    Configurations configurations unless configurations.empty?
    InstanceCount instance_count
    InstanceType instance_type
    Market market.upcase
    Name name
  }
end

def _emr_hadoop_jar_step_config(args)
  config_args = args[:args] || []
  jar = args[:jar]
  main_class = args[:main_class] || ""
  step_properties = _pair_value(args, "step")

  _{
    Args config_args unless config_args.empty?
    Jar jar
    MainClass main_class unless main_class.empty?
    StepProperties step_properties unless step_properties.empty?
  }
end

def _emr_instance_autoscaling(args)
  autoscaling = args[:autoscaling] || ""
  return "" if autoscaling.empty?

  rules = _emr_instance_autoscaling_rules(autoscaling)

  _{
    Constraints do
      MaxCapacity autoscaling[:max]
      MinCapacity autoscaling[:min]
    end
    Rules rules
  }
end

def _emr_instance_autoscaling_rules(args)
  rules = args[:rules] || []

  rules.collect do |rule|
    action = _emr_instance_autoscaling_rule_action(rule)
    name = _name("rule", rule)
    description = _ref_string_default("description", rule, '', "#{name} instance autoscaling rules description")
    trigger = _emr_instance_autoscaling_rule_trigger(rule)
    _{
      Action action
      Description description
      Name name
      Trigger trigger
    }
  end
end

def _emr_instance_autoscaling_rule_action(args)
  market = _valid_values(args[:market] || "", %w( on_demand, spot), "on_demand")
  simple = _emr_instance_autoscaling_rule_action_simple(args)

  _{
    Market market.upcase
    SimpleScalingPolicyConfiguration simple
 }
end

def _emr_instance_autoscaling_rule_action_simple(args)
  adjustment =
    case args[:type]
    when "change"
      "CHANGE_IN_CAPACITY"
    when "percent"
      "PERCENT_CHANGE_IN_CAPACITY"
    when "exact"
      "EXACT_CAPACITY"
    else
      "CHANGE_IN_CAPACITY"
    end
  cool = args[:cool] || 0
  scaling = args[:scaling]

  _{
    AdjustmentType adjustment
    CoolDown cool
    ScalingAdjustment scaling
  }
end

def _emr_instance_autoscaling_rule_trigger(args)
  operator =
    case args[:operator]
    when ">="
      "GREATER_THAN_OR_EQUAL"
    when ">"
      "GREATER_THAN"
    when "<"
      "LESS_THAN"
    when "<="
      "LESS_THAN_OR_EQUAL"
    else
      "GREATER_THAN_OR_EQUAL"
    end
  dimensions = _pair_value(args, "dimensions")
  evaluation = args[:evaluation] || 1
  name = _name("definition", args)
  ns = args[:ns] || "AWS/ElasticMapReduce"
  period = args[:period] || 300
  statistic = _valid_values(args[:statistic],
                            %w( sample_count average sum minimum maximum ), "average")
  threshold = args[:threshold]
  unit = _cloudwatch_to_unit(args[:unit])

  _{
    CloudWatchAlarmDefinition do
      ComparisonOperator operator
      Dimensions dimensions unless dimensions.empty?
      EvaluationPeriods evaluation
      MetricName name
      Namespace ns
      Period period
      Statistic statistic.upcase
      Threshold threshold
      Unit unit
    end
  }
end
