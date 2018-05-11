#
# Helper - EMR
#
require 'kumogata/template/helper'


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

  array = []
  applications.each do |application|
    args = application[:args] || []
    array << _{
      #AdditionalInfo
      Args args unless args.empty?
      Name application[:name].capitalize
      Version application[:version] if application.key? :version
    }
  end
  array
end

def _emr_bootstraps(args)
  actions = args[:bootstraps] || []

  array = []
  actions.each do |action|
    array << _{
      Name action[:name]
      ScriptBootstrapAction _{
        Args action[:script_args] if action.key? :script_args
        Path action[:script_path]
      }
    }
  end
  array
end

def _emr_configurations(args)
  configurations = args[:configurations] || []

  array = []
  configurations.each do |configuration|
    classification = configuration[:classification] || ""
    properties = configuration[:properties] || {}
    configuring = _emr_configuring(configuration)
    array << _{
      Classification classification unless classification.empty?
      ConfigurationProperties properties
      Configurations configuring
    }
  end
  array
end

def _emr_configuring(args)
  configurations = args[:configurations] || []

  array = []
  configurations.each do |configuration|
    classification = configuration[:classification] || ""
    properties = configuration[:properties] || {}
    array << _{
      Classification classification unless classification.empty?
      ConfigurationProperties properties
      Configurations []
    }
  end
  array
end

def _emr_ebs(args)
  ebs = args[:ebs] || []
  return '' if ebs.empty?
  ebs_block_devices = ebs.collect{|v| _emr_ebs_block_device(v) }

  _{
    EbsBlockDeviceConfigs ebs_block_devices unless ebs_block_devices.empty?
    #EbsOptimized
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
  core_instance_group = _emr_instance_group(job[:core])
  key_name = _ref_string("key_name", job, "key name")
  subnet = _ref_string("subnet", job, "subnet")
  emr_master_security_group = _ref_string("emr_master_security_group", job, "security group")
  emr_slave_security_group = _ref_string("emr_slave_security_group", job, "security group")
  hadoop_version = _valid_values("hadoop", %w( 1.0.3 2.2.0 2.4.0 ))
  master = _emr_instance_group(job[:master])
  placement = job[:placement] || ""
  service_access_security_group = _ref_string("service_access_security_group", job, "security group")
  termination = _bool("termination", job, false)

  _{
    AdditionalMasterSecurityGroups add_master_security_groups unless add_master_security_groups.empty?
    AdditionalSlaveSecurityGroups add_slave_security_groups unless add_slave_security_groups.empty?
    CoreInstanceGroup core_instance_group
    Ec2KeyName key_name unless key_name.empty?
    Ec2SubnetId subnet unless subnet.empty?
    EmrManagedMasterSecurityGroup emr_master_security_group unless emr_master_security_group.empty?
    EmrManagedSlaveSecurityGroup emr_slave_security_group unless emr_slave_security_group.empty?
    HadoopVersion hadoop_version unless hadoop_version.nil?
    MasterInstanceGroup master
    Placement _{
      AvailabilityZone placement
    } unless placement.empty?
    ServiceAccessSecurityGroup service_access_security_group unless service_access_security_group.empty?
    TerminationProtected termination
  }
end

def _emr_instance_group(args)
  bid = args[:bid] || ""
  configurations = _emr_configurations(args)
  ebs_configuration = _emr_ebs(args)
  instance_count = args[:instance_count] || 1
  instance_type = _ref_string("instance_type", args, "instance type")
  instance_type = EMR_DEFAULT_INSTANCE_TYPE  if instance_type.empty?
  market = _valid_values("market", %w( on_demand, spot), "on_demand")
  name = _ref_name("name", args)

  _{
    BidPrice bid unless bid.empty?
    Configurations configurations unless configurations.empty?
    EbsConfiguration ebs_configuration unless ebs_configuration.empty?
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
  step_properties = _emr_step_properties(args)

  _{
    Args config_args unless config_args.empty?
    Jar jar
    MainClass main_class unless main_class.empty?
    StepProperties step_properties unless step_properties.empty?
  }
end

def _emr_step_properties(args)
  properties = args[:step_properties] || []

  array = []
  properties.each do |property|
    array << _{
      Key property[:key]
      Value property[:value]
    }
  end
  array
end
