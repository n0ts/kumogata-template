#
# Helper - Elasticbeanstalk
#
require 'kumogata/template/helper'
require 'kumogata/template/ec2'
require 'kumogata/template/sns'

def _elasticbeanstalk_to_option_asg(args)
  array = []
  array << {
    name: "aws:autoscaling:asg",
    option: "AvailabilityZone",
    value: args[:az],
  } if args.key? :az
  array << {
    name: "aws:autoscaling:asg",
    option: "Cooldown",
    value: args[:cooldown] || 360,
  }
  array << {
    name: "aws:autoscaling:asg",
    option: "CusotomAvailabilityZones",
    value: _ref_array("custuom_az"),
  } if args.key? :custom_az
  array << {
    name: "aws:autoscaling:asg",
    option: "MinSize",
    value: args[:min_size] || 1,
  }
  array << {
    name: "aws:autoscaling:asg",
    option: "MaxSize",
    value: args[:max_size] || 4,
  }
  array
end

def _elasticbeanstalk_to_option_launch_configuration(args)
  array = []
  array << {
    name: "aws:autoscaling:launchconfiguration",
    option: "EC2KeyName",
    value: _ref_string("key_name", args),
  }
  array << {
    name: "aws:autoscaling:launchconfiguration",
    option: "IamInstanceProfile",
    value: _ref_string_default("instance_profile", args, '',
                               ELASTIC_BEANTALK_EC2_DEFAULT_ROLE),
  }
  array << {
    name: "aws:autoscaling:launchconfiguration",
    option: "ImageId",
    value: _ref_string("image_id", args),
  } if args.key? :image_id
  array << {
    name: "aws:autoscaling:launchconfiguration",
    option: "InstanceType",
    value: _ref_string_default("instance_type", args, '',
                               EC2_DEFAULT_INSTANCE_TYPE),
  }
  array << {
    name: "aws:autoscaling:launchconfiguration",
    option: "MonitoringInterval",
    value: args[:monitoring] || "5 minute",
  }
  array << {
    name: "aws:autoscaling:launchconfiguration",
    option: "SecurityGroups",
    value: _join(_ref_array("security_groups", args)),
  } if _ref_key?("security_groups", args)
  array << {
    name: "aws:autoscaling:launchconfiguration",
    option: "SSHSourceRestriction",
    value: args[:ssh_source],
  } if args.key? :ssh_source
  array << {
    name: "aws:autoscaling:launchconfiguration",
    option: "BlockDeviceMappings",
    value: args[:block_devices].collect{|v| _ec2_block_device(v) },
  } if _ref_key?(:block_devices, args)
  array << {
    name: "aws:autoscaling:launchconfiguration",
    option: "RootVolumeType",
    value: _ref_string_default("root_volume_type", args, '', 'gp2'),
  }
  array << {
    name: "aws:autoscaling:launchconfiguration",
    option: "RootVolumeSize",
                           #ref_root_volume_size
    value: _ref_string_default("root_volume_size", args, '', 10),
  }
  array << {
    name: "aws:autoscaling:launchconfiguration",
    option: "RootVolumeIOPS",
    value: _ref_string("root_volume_iops", args),
  } if _ref_key?("root_volume_iops", args)
  array
end

def _elasticbeanstalk_to_option_scheduled_action(args)
  array = []
  array << {
    name: "aws:autoscaling:scheduledaction",
    option: "DesiredCapacity",
    value: args[:desired],
  } if args.key? :desired
  array << {
    name: "aws:autoscaling:scheduledaction",
    option: "EndTime",
    value: _time_utc(args[:end_time]),
  } if args.key? :end_time
  array << {
    name: "aws:autoscaling:scheduledaction",
    option: "MaxSize",
    value: args[:max_size],
  } if args.key? :max_size
  array << {
    name: "aws:autoscaling:scheduledaction",
    option: "MinSize",
    value: args[:min_size],
  } if args.key? :min_size
  array << {
    name: "aws:autoscaling:scheduledaction",
    option: "Recurrence",
    value: _autoscaling_to_schedued_recurrence(args[:recurrence]),
  } if args.key? :recurrence
  array << {
    name: "aws:autoscaling:scheduledaction",
    option: "StartTime",
    value: _time_utc(args[:start_time]),
  } if args.key? :start_time
  array << {
    name: "aws:autoscaling:scheduledaction",
    option: "Suspend",
    value: _bool("suspend", args, false),
  } if args.key? :suspend
  array
end

def _elasticbeanstalk_to_option_trigger(args)
  array = []
  array << {
    name: "aws:autoscaling:trigger",
    option: "BreachDuration",
    value: args[:breach_duration] || 5, # 1 to 600
  }
  array << {
    name: "aws:autoscaling:trigger",
    option: "LowerBreachScaleIncrement",
    value: args[:lower_breach] || -2,
  }
  array << {
    name: "aws:autoscaling:trigger",
    option: "LowerThreshold",
    value: args[:lower_threshold] || 200000, # 0 to 20000000
  }
  array << {
    name: "aws:autoscaling:trigger",
    option: "MeasureName",
    value: _valid_values(args[:measure],
                         %w( CPUUtilization
                             NetworkIn NetworkOut
                             DiskWriteBytes DiskWriteOps
                             DiskReadBytes DiskReadOps
                             Latency RequestCount HealthyHostCount UnhealthyHostCount ),
                         "NetworkOut"),
  }
  array << {
    name: "aws:autoscaling:trigger",
    option: "Period",
    value: args[:period] || 5,
  }
  array << {
    name: "aws:autoscaling:trigger",
    option: "Statistic",
    value: _valid_values(args[:statistic],
                         %w( Minimum Maximum Sum Average ), "Average")
  }
  array << {
    name: "aws:autoscaling:trigger",
    option: "Unit",
    value: _valid_values(args[:unit],
                        %w( Seconds Percent Bytes Bits Count
                            Bytes/Second Bits/Second Count/Second None ), "Bytes"),
  }
  array << {
    name: "aws:autoscaling:trigger",
    option: "UpperThreshold",
    value: args[:upper_breach] || 1,
  }
  array << {
    name: "aws:autoscaling:trigger",
    option: "UpperThreshold",
    value: args[:lower_threshold] || 6000000, # 0 to 20000000
  }
  array
end

def _elasticbeanstalk_to_rolling_update(args)
  array = []
  array << {
    name: "aws:autoscaling:updatepolicy:rollingupdate",
    option: "MaxBatchSize",
    value: args[:max_batch_size], # 1 to 10000
  } if args.key? :max_batch_size
  array << {
    name: "aws:autoscaling:updatepolicy:rollingupdate",
    option: "MinInstanceInService",
    value: args[:min_instance], # 0 to 9999
  } if args.key? :min_instance
  array << {
    name: "aws:autoscaling:updatepolicy:rollingupdate",
    option: "RollingUpdateEnabled",
    value: _bool("enabled", args, false),
  }
  array << {
    name: "aws:autoscaling:updatepolicy:rollingupdate",
    option: "RollingUpdateType",
    value: _valid_values(args[:type], %w( Time Health Immutable ), "Time"),
  }
  array << {
    name: "aws:autoscaling:updatepolicy:rollingupdate",
    option: "PauseTime",
    value: _timestamp_utc_duration(args[:pause_time][:minute],
                                   args[:pause_time][:hour],
                                   args[:pause_time][:second]),
  } if args.key? :pause_time
  array << {
    name: "aws:autoscaling:updatepolicy:rollingupdate",
    option: "Timeout",
    value: _timestamp_utc_duration(args[:timeout][:minute],
                                   args[:timeout][:hour],
                                   args[:timeout][:second])
  } if args.key? :timeout
  array
end

def _elasticbeanstalk_to_option_vpc(args)
  array = []
  array << {
    name: "aws:ec2:vpc",
    option: "VpcId",
    value: _ref_string("vpc", args, "vpc"),
  }
  array << {
    name: "aws:ec2:vpc",
    option: "Subnets",
    value: _join(_ref_array("subnets", args)),
  }
  array << {
    name: "aws:ec2:vpc",
    option: "ELBSubnets",
    value: _join(_ref_array("elb_subnets", args)),
  } if args.key? :elb
  array << {
    name: "aws:ec2:vpc",
    option: "ELBScheme",
    value: "internal",
  } if args.key? :elb
  array << {
    name: "aws:ec2:vpc",
    option: "DBSubnets",
    valiue: _join(_ref_array("db_subnets", args)),
  } if args.key? :db
  array << {
    name: "aws:ec2:vpc",
    option: "AssociatePublicIpAddress",
    value: _bool("is_public", args),
  } if args.key :is_public
  array
end

def _elasticbeanstalk_to_option_application(args)
  array = []
  array << {
    name: "aws:elasticbeanstalk:application",
    option: "ApplicationHealthcheckURL",
    value: args[:health_check],
  } if args.key? :health_check
  array
end

def _elasticbeanstalk_to_option_application_environment(args)
  args.collect do |k, v|
    {
      name: "aws:elasticbeanstalk:application:environment",
      option: k,
      value: v,
    }
  end
end

def _elasticbeanstalk_to_option_logs(args)
  array = []
  array << {
    name: "aws:elasticbeanstalk:cloudwatch:logs",
    option: "StreamLogs",
    value: _bool("stream", args, false),
  }
  array << {
    name: "aws:elasticbeanstalk:cloudwatch:logs",
    option: "DeleteOnTerminate",
    value: _bool("terminate", args, false),
  }
  array << {
    name: "aws:elasticbeanstalk:cloudwatch:logs",
    option: "RetentionInDays",
    value: _valid_values(args[:rentetion],
                         %w( 1 3 7 14 30 60 90 120 150 180 365 400 545 731 1827 3653 )),
  }
  array
end

def _elasticbeanstalk_to_option_command(args)
  array = []
  array << {
    name: "aws:elasticbeanstalk:command",
    option: "DeploymentPolicy",
    value: _valid_values(args[:deployment],
                         %w( AllAtOnce Rolling RollingWithAdditionalBatch Immutable ),
                         "AllAtOnce"),
  }
  array << {
    name: "aws:elasticbeanstalk:command",
    option: "Timeout",
    value: args[:timeout] || 600, # 1 to 3600
  }
  array << {
    name: "aws:elasticbeanstalk:command",
    option: "BatchSizeType",
    value: _valid_values(args[:batch_size_type],
                         %w( Percentage Fixed ), "Percentage"),
  }
  array << {
    name: "aws:elasticbeanstalk:command",
    option: "BatchSize",
    value: args[:batch_size] || 1, # Percentage: 1 to 100, Fixed: 1 to aws:autoscaling:MaxSize
  }
  array << {
    name: "aws:elasticbeanstalk:command",
    option: "IgnoreHealthCheck",
    value: _bool("ignore_health_check", args, false),
  }
  array << {
    name: "aws:elasticbeanstalk:command",
    option: "HealthCheckSuccessThreshold",
    value: _valid_values(args[:health_check_success],
                         %w( Ok Warning Degraded Severe ), "Ok"),
  }
  array
end

def _elasticbeanstalk_to_option_environment(args)
  array = []
  array << {
    name: "aws:elasticbeanstalk:environment",
    option: "EnvironmentType",
    value: _valid_values(args[:type],
                         %w( SingleInstance LoadBalanced ), "LoadBalanced"),
  }
  array << {
    name: "aws:elasticbeanstalk:environment",
    option: "ServiceRole",
    value: args[:service_role] || "aws-elasticbeanstalk-service-role",
  }
  array << {
    name: "aws:elasticbeanstalk:environment",
    option: "LoadBalancerType",
    value: _valid_values(args[:load_balancer_type],
                         %w( classic application ), "application")
  } if args.key? :load_balancer_type
  array
end

def _elasticbeanstalk_to_option_process(args, name = "default")
  array = []
  array << {
    name: "aws:elasticbeanstalk:environment:process:#{name}",
    option: "DeregistrationDelay",
    value: args[:deregistration] || 20, # 0 to 3600
  }
  array << {
    name: "aws:elasticbeanstalk:environment:process:#{name}",
    option: "HealthCheckInterval",
    value: args[:health_chek_interval] || 15, # 15 to 300
  }
  array << {
    name: "aws:elasticbeanstalk:environment:process:#{name}",
    option: "HealthCheckPath",
    value: args[:health_check_path] || "/",
  }
  array << {
    name: "aws:elasticbeanstalk:environment:process:#{name}",
    option: "HealthCheckTimeout",
    value: args[:health_check_timeout] || 5, # 1 to 60
  }
  array << {
    name: "aws:elasticbeanstalk:environment:process:#{name}",
    option: "HealthyThresholdCount",
    value: args[:healthy] || 3, # 1 to 10
  }
  array << {
    name: "aws:elasticbeanstalk:environment:process:#{name}",
    option: "MatcherHTTPCode",
    value: args[:matcher_http] || 200, # 200 to 399
  }
  array << {
    name: "aws:elasticbeanstalk:environment:process:#{name}",
    option: "Port",
    value: args[:port] || 80, # 1 to 65535
  }
  array << {
    name: "aws:elasticbeanstalk:environment:process:#{name}",
    option: "Protocol",
    value: _valid_values(args[:protocol], %w( HTTP HTTPS ), "HTTP"),
  }
  array << {
    name: "aws:elasticbeanstalk:environment:process:#{name}",
    option: "StickinessEnabled",
    value: _bool("stickiness_enabled", args, false),
  }
  array << {
    name: "aws:elasticbeanstalk:environment:process:#{name}",
    option: "StickinessLBCookieDuration",
    value: args[:stickiness_lb_cookie_duration] || 86400, # 1 to 604800
  }
  array << {
    name: "aws:elasticbeanstalk:environment:process:#{name}",
    option: "StickinessType",
    value: "lb_cookie",
  } if args.key? :stickiness_type
  array << {
    name: "aws:elasticbeanstalk:environment:process:#{name}",
    option: "UnhealthyThresholdCount",
    value: args[:uhealth] || 5, # 2 to 10
  }
  array
end

def _elasticbeanstalk_to_option_healthreporting_system(args)
  array = []
  array << {
    name: "aws:elasticbeanstalk:healthreporting:system",
    option: "SystemType",
    value: _valid_values(args[:type], %w( basic enhanced ), "basic"),
  }
  array << {
    name: "aws:elasticbeanstalk:healthreporting:system",
    option: "ConfigDocument",
    value: args[:config],
  } if args.key? :config
  array
end

def _elasticbeanstalk_to_option_host_manager(args)
  array = []
  array << {
    name: "aws:elasticbeanstalk:hostmanager",
    option: "LogPublicationControl",
    value: _bool("log_publication", args, false),
  }
  array
end

def _elasticbeanstalk_to_option_managed_actions(args)
  array = []
  array << {
    name: "aws:elasticbeanstalk:managedactions",
    option: "ManagedActionsEnabled",
    value: _bool("enabled", args, false),
  }
  array << {
    name: "aws:elasticbeanstalk:managedactions",
    option: "PreferredStartTime",
    value: args[:time].utc.strftime("%a:%H:%M"),
  } if args.key? :time
  array
end

def _elasticbeanstalk_to_option_platform_update(args)
  array = []
  array << {
    name: "aws:elasticbeanstalk:managedactions:platformupdate",
    option: "UpdateLevel",
    value: args[:level],
  } if args.key? :level
  array << {
    name: "aws:elasticbeanstalk:managedactions:platformupdate",
    option: "InstanceRefreshEnabled",
    value: _bool("enabled", args, false),
  }
  array
end

def _elasticbeanstalk_to_option_monitoring(args)
  array = []
  array << {
    name: "aws:elasticbeanstalk:managedactions:monitoring",
    option: "Automatically Terminate Unhealthy Instances",
    value: _bool("automatically", args, true),
  }
  array
end

def _elasticbeanstalk_to_option_sns_topics(args)
  array = []
  array << {
    name: "aws:elasticbeanstalk:sns:topics",
    option: "Notification Endpoint",
    value: args[:endpoint],
  } if args.key? :endpoint
  array << {
    name: "aws:elasticbeanstalk:sns:topics",
    option: "Notification Protocol",
    value: _sns_to_protocol(args[:protocol]),
  }
  array << {
    name: "aws:elasticbeanstalk:sns:topics",
    option: "Notification Topic ARN",
    value: args[:topic_arn],
  } if args.key? :topic_arn
  array << {
    name: "aws:elasticbeanstalk:sns:topics",
    option: "Notification Topic Name",
    value: args[:topic_name],
  } if args.key? :topic_name
  array
end

def _elasticbeanstalk_to_option_sqsd(args)
  array = []
  array << {
    name: "aws:elasticbeanstalk:sqsd",
    option: "WorkerQueueURL",
    value: args[:worker_queue_url],
  } if args.key? :worker_queue_url
  array << {
    name: "aws:elasticbeanstalk:sqsd",
    option: "HttpPath",
    value: args[:http_path] || "/",
  }
  array << {
    name: "aws:elasticbeanstalk:sqsd",
    option: "MimeType",
    value: args[:mime_type],
  } if args.key? :mime_type
  array << {
    name: "aws:elasticbeanstalk:sqsd",
    option: "HttpConnections",
    value: args[:http_connections] || 15, # 1 to 100
  }
  array << {
    name: "aws:elasticbeanstalk:sqsd",
    option: "ConnectTimeout",
    value: args[:connect_timeout] || 5, # 1 to 60
  }
  array << {
    name: "aws:elasticbeanstalk:sqsd",
    option: "InactivityTimeout",
    value: args[:inactivity_timeout] || 180, # 1 to 1800
  }
  array << {
    name: "aws:elasticbeanstalk:sqsd",
    option: "VisibilityTimeout",
    value: args[:visibility_timeout] || 300, # 0 to 43200
  }
  array << {
    name: "aws:elasticbeanstalk:sqsd",
    option: "ErrorVisibilityTimeout",
    value: args[:error_visibility_timeout] || 300, # 0 to 43200
  }
  array << {
    name: "aws:elasticbeanstalk:sqsd",
    option: "RetentionPeriod",
    value: args[:retention] || 345600, # 60 to 1209600
  }
  array << {
    name: "aws:elasticbeanstalk:sqsd",
    option: "MaxRetries",
    value: args[:max_retries] || 10, # 1 to 100
  }
  array
end

def _elasticbeanstalk_to_option_elb_health_check(args)
  array = []
  array << {
    name: "aws:elb:healthcheck",
    option: "HealthyThreshold",
    value: args[:healthy] || 3, # 2 to 10
  }
  array << {
    name: "aws:elb:healthcheck",
    option: "Interval",
    value: args[:interval] || 10, # 5 to 300
  }
  array << {
    name: "aws:elb:healthcheck",
    option: "Timeout",
    value: args[:timeout] || 5, # 2 to 60
  }
  array << {
    name: "aws:elb:healthcheck",
    option: "UnhealthyThreshold",
    value: args[:unhealthy] || 5, # 2 to 10
  }
  array
end

def _elasticbeanstalk_to_option_elb_loadbalancer(args)
  array = []
  array << {
    name: "aws:elb:loadbalancer",
    option: "CrossZone",
    value: _bool("cross", args, true),
  }
  array << {
    name: "aws:elb:loadbalancer",
    option: "SecurityGroups",
    value: _join(_ref_array("security_groups", args)),
  }
  array << {
    name: "aws:elb:loadbalancer",
    option: "ManagedSecurityGroup",
    value: args[:managed_security_group],
  } if args.key? :managed_security_group
  array
end

def _elasticbeanstalk_to_option_elb_listener(args)
  array = []
  array << {
    name: "aws:elb:listener",
    option: "ListenerProtocol",
    value: _valid_values(args[:protocol], %w( HTTP TCP ), "HTTP"),
  }
  array << {
    name: "aws:elb:listener",
    option: "InstancePort",
    value: args[:instance_port] || 80, # 1 to 65535
  } if args.key? :instance_port
  array << {
    name: "aws:elb:listener",
    option: "InstanceProtocol",
    value: args[:instance_protocol],
  }
  array << {
    name: "aws:elb:listener",
    option: "PolicyNames",
    value: args[:policy_names],
  } if args.key? :policy_names
  array << {
    name: "aws:elb:listener",
    option: "ListenerEnabled",
    value: _bool("enabled", args, true),
  }
  array
end

def _elasticbeanstalk_to_option_elb_listener_port(args, port)
  array = []
  array << {
    name: "aws:elb:listener:#{port}",
    option: "ListenerProtocol",
    value: _valid_values(args[:protocol], %w( HTTP TCP ), "HTTP"),
  }
  array << {
    name: "aws:elb:listener:#{port}",
    option: "InstancePort",
    value: args[:instance_port] || 80, # 1 to 65535
  } if args.key? :instance_port
  array << {
    name: "aws:elb:listener:#{port}",
    option: "InstanceProtocol",
    value: args[:instance_protocol],
  }
  array << {
    name: "aws:elb:listener:#{port}",
    option: "PolicyNames",
    value: args[:policy_names],
  } if args.key? :policy_names
  array << {
    name: "aws:elb:listener:#{port}",
    option: "SSLCertificateId",
    value: args[:ssl_certificate],
  } if args.key? :ssl_cretificate
  array << {
    name: "aws:elb:listener:#{port}",
    option: "ListenerEnabled",
    value: _bool("enabled", args, true),
  }
  array
end

def _elasticbeanstalk_to_option_elb_policies(args)
  array = []
  array << {
    name: "aws:elb:policies",
    option: "ConnectionDrainingEnabled",
    value: _bool("connection_draining_enabled", args, false),
  }
  array << {
    name: "aws:elb:policies",
    option: "ConnectionDrainingTimeout",
    value: args[:connection_draining_timeout] || 20, # 1 to 3600
  }
  array << {
    name: "aws:elb:policies",
    option: "ConnectionSettingIdleTimeout",
    value: args[:connection_draining_idle], # 1 to 3600
  }
  array << {
    name: "aws:elb:policies",
    option: "LoadBalancerPorts",
    value: args[:load_balancer_ports],
  } if args.key? :load_balancer_ports
  array << {
    name: "aws:elb:policies",
    option: "Stickiness Cookie Expiration",
    value: args[:stickiness_cookie_expiration], # 0 to 1000000
  } if args.key? :stickiness_cookie_expiration
  array << {
    name: "aws:elb:policies",
    option: "Stickiness Policy",
    value: _bool("stickiness_policy", args, false),
  }
  array
end

def _elasticbeanstalk_to_option_elb_policy_name(args, name)
  array = []
  array << {
    name: "aws:elb:policies:#{name}",
    option: "CookieName",
    value: args[:cookie_name],
  } if args.key? :cookie_name
  array << {
    name: "aws:elb:policies:#{name}",
    option: "InstancePorts",
    value: args[:instance_ports],
  } if args.key? :instance_ports
  array << {
    name: "aws:elb:policies:#{name}",
    option: "LoadBalancerPorts",
    value: args[:load_balancer_ports],
  } if args.key? :load_balancer_ports
  array << {
    name: "aws:elb:policies:#{name}",
    option: "ProxyProtocol",
    value: args[:proxy_protocol],
  } if args.key? :proxy_protocol
  array << {
    name: "aws:elb:policies:#{name}",
    option: "PublicKey",
    value: args[:public_key],
  } if args.key? :public_key
  array << {
    name: "aws:elb:policies:#{name}",
    option: "PublicKeyPolicyNames",
    value: args[:public_key_policy_names],
  } if args.key? :public_key_policy_names
  array << {
    name: "aws:elb:policies:#{name}",
    option: "SSLProtocols",
    value: args[:ssl_protocols],
  } if args.key? :ssl_protocols
  array << {
    name: "aws:elb:policies:#{name}",
    option: "SSLReferencePolicy",
    value: args[:ssl_reference],
  } if args.key? :ssl_reference
  array << {
    name: "aws:elb:policies:#{name}",
    option: "Stickiness Cookie Expiration",
    value: args[:stickiness_cookie_expiration], # 0 to 1000000
  } if args.key? :stickiness_cookie_expiration
  array << {
    name: "aws:elb:policies:#{name}",
    option: "Stickiness Policy",
    value: _bool("stickiness_policy", args, false),
  }
  array
end

def _elasticbeanstalk_to_option_elbv2_listener(args, name = "default")
  array = []
  array << {
    name: "aws:elbv2:listener:#{name}",
    option: "DefaultProcess",
    value: args[:process] || "default",
  }
  array << {
    name: "aws:elbv2:listener:#{name}",
    option: "ListenerEnabled",
    value: _bool("enabled", args, true),
  }
  array << {
    name: "aws:elbv2:listener:#{name}",
    option: "Rules",
    value: _join(args[:rules]),
  } if args.key? :rules
  if name != "default"
    array << {
      name: "aws:elbv2:listener:listener_port",
      option: "SSLCertificateArns",
      value: args[:ssl_certificate_arns],
    } if args.key? :ssl_certificate_arns
    array << {
      name: "aws:elbv2:listener:listener_port",
      option: "SSLPolicy",
      value: args[:ssl_policy],
    } if args.key? :ssl_policy
  end
  array
end

def _elasticbeanstalk_to_option_elbv2_listener_rule(args, name)
  array = []
  array << {
    name: "aws:elbv2:listenerrule:#{name}",
    option: "PathPatterns",
    value: args[:path],
  } if args.key? :path
  array << {
    name: "aws:elbv2:listenerrule:#{name}",
    option: "Priority",
    value: args[:priority] || 1, # 1 to 1000
  }
  array << {
    name: "aws:elbv2:listenerrule:#{name}",
    option: "Process",
    value: args[:process] || "default",
  }
  array
end

def _elasticbeanstalk_to_option_elbv2_load_balancer(args)
  array = []
  array << {
    name: "aws:elbv2:loadbalancer",
    option: "AccessLogsS3Bucket",
    value: args[:access_logs_s3_bucket],
  } if args.key? :access_logs_s3_bucket
  array << {
    name: "aws:elbv2:loadbalancer",
    option: "AccessLogsS3Enabled",
    value: _bool("access_logs_s3", args, false),
  }
  array << {
    name: "aws:elbv2:loadbalancer",
    option: "AccessLogsS3Prefix",
    value: args[:access_logs_s3_prefix],
  } if args.key? :access_logs_s3_prefix
  array << {
    name: "aws:elbv2:loadbalancer",
    option: "IdleTimeout",
    value: args[:idle_timeout],
  } if args.key? :idle_timeout
  array << {
    name: "aws:elbv2:loadbalancer",
    option: "ManagedSecurityGroup",
    value: args[:managed_security_group],
  } if args.key? :managed_security_group
  array << {
    name: "aws:elbv2:loadbalancer",
    option: "SecurityGroups",
    value: _join(_ref_array("security_groups", args)),
  }
end

def _elasticbeanstalk_to_option_rds_db_instance(args)
  array = []
  array << {
    name: "aws:rds:dbinstance",
    option: "DBAllocatedStorage",
    value: args[:allocated_storage], # MySQL:5-1024
  } if args.key? :allocated_storage
  array << {
    name: "aws:rds:dbinstance",
    option: "DBDeletionPolicy",
    value: _valid_values(args[:deletion_policy], %w( Delete Snapshot ), "Delete"),
  }
  array << {
    name: "aws:rds:dbinstance",
    option: "DBEngine",
    value: _valid_values(args[:engine],
                         %w( mysql
                             oracle-se1 oracle-se oracle-ee
                             sqlserver-ee sql-server-ex sqlserver-web sqlserver-se
                             postgres ), "mysql"),
  }
  array << {
    name: "aws:rds:dbinstance",
    option: "DBEngineVersion",
    value: args[:engine_version] || "5.7",
  }
  array << {
    name: "aws:rds:dbinstance",
    option: "DBInstanceClass",
    value: _valid_values(args[:instance_class],
                         RDS_INSTANCE_CLASSES, RDS_DEFAULT_INSTANCE_CLASS),
  }
  array << {
    name: "aws:rds:dbinstance",
    option: "DBPassword",
    value: args[:password],
  } if args.key? :password
  array << {
    name: "aws:rds:dbinstance",
    option: "DBSnapshotIdentifier",
    value: args[:snapshot],
  } if args.key? :snapshot
  array << {
    name: "aws:rds:dbinstance",
    option: "DBUser",
    value: args[:user] || "ebroot",
  }
  array << {
    name: "aws:rds:dbinstance",
    option: "MultiAZDatabase",
    value: _bool("multi_az", args, false),
  }
  array
end

def _elasticbeanstalk_options(options)
  options.collect do |option|
    _{
      Namespace option[:name]
      OptionName option[:option]
      Value option[:value]
    }
  end
end

def _elasticbeanstalk_configuration(configuration)
  _{
    ApplicationName configuration[:application]
    TemplateName configuration[:template]
  }
end

def _elasticbeanstalk_tier(tier)
  if tier.is_a? String
    case tier.downcase
    when "web", "webserver"
      name = "WebServer"
    when "work", "worker"
      name = "Worker"
    else
      name = "WebServer"
    end
    tier = { name: name }
  end

  name = _valid_values(tier[:name], %w( WebServer Worker ), "WebServer")

  _{
    Name name
    Type (name == "WebServer") ? "Standard" : "SQS/HTTP"
    Version tier[:version] || "1.0"
  }
end
