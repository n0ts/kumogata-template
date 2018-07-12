#
# Helper - ECS
#
require 'kumogata/template/helper'

def _ecs_to_log_option(args)
  option =
    case args[:driver]
    when "awslogs"
      _ecs_to_log_option_awslogs(args)
    when "fluentd"
      _ecs_to_log_option_fluentd(args)
    when "syslog"
      _ecs_to_log_option_syslog(args)
    when "json"
      _ecs_to_log_option_syslog(args)
    when "splunk"
      _ecs_to_log_option_splunk(args)
    when "gelf"
      _ecs_to_log_option_gelf(args)
    else
      {}
  end
  option.merge(_ecs_to_log_option_common(args))
end

def _ecs_to_log_option_awslogs(args)
  {
    "awslogs-group": args[:group],
    "awslogs-region": args[:region] || _region,
    "awslogs-stream-prefix": args[:prefix] || "",
  }
end

def _ecs_to_log_option_fluentd(args)
  option = {
    "fluentd-address": args[:address] || "localhost:24224",
    "fluentd-retry-wait": args[:retry_wait] || 1,
    "fluentd-max-retries": args[:max_retries] || 10,
  }
  option["fluentd-async-connect"] = true if args.key? :async
  option["fluentd-buffer-limit"] = args[:buffer_limit] if args.key? :buffer_limit
  option
end

def _ecs_to_log_option_syslog(args)
  option = {
    "syslog-address": args[:address],
  }
  option["syslog-facility"] = args[:facility] if args.key? :facility
  option["syslog-tls-ca-cert"] = args[:ca_cert] if args.key? :ca_cert
  option["syslog-tls-cert"] = args[:cert] if args.key? :cert
  option["syslog-tls-key"] = args[:key] if args.key? :key
  option["syslog-tls-skip-verify"] = true if args.key? :skip_verify
  option["syslog-format"] = args[:format] if args.key? :format
  option
end

def _ecs_to_log_option_json(args)
  option = {
    "max-size": args[:max_size] || "10m",
    "max-file": args[:max_file] || 1,
  }
  option
end

def _ecs_to_log_option_splunk(args)
  option = {
    "splunk-token": args[:token],
    "splunk-url": args[:url],
    "splunk-verify-connection": _bool("veriy_connection", args, true),
    "splunk-gzip": _bool("gzip", args, false),
  }
  option["splunk-source"] = args[:source] if args.key? :source
  option["splunk-sourcetype"] = args[:source_type] if args.key? :source_type
  option["splunk-index"] = args[:index] if args.key? :index
  option["splunk-capath"] = args[:capath] if args.key? :capath
  option["splunk-caname"] = args[:caname] if args.key? :caname
  option["splunk-insecureskipverify"] = true if args.key? :skip_verify
  option["splunk-format"] = args[:format] if args.key? :format
  option["splunk-gzip-level"] = args[:gzip_level] if args.key? :gzip_label
  option
end

def _ecs_to_log_option_gelf(args)
  option = {
    "gelf-address": args[:address],
    "gelf-compression-type": args[:type] || "gzip",
  }
  option["gelf-compression-level"] = args[:level] if args.key? :level
  option
end

def _ecs_to_log_option_common(args)
  option = {}
  option[:labels] = args[:labels].join(',') if args.key? :labels
  option[:env] = args[:envs].join(',') if args.key? :envs
  option["env-regex"] = args[:env_regex] if args.key? :env_regex
  option[:tag] = args[:tag] if args.key? :tag
  option
end

def _ecs_volumes(args)
  (args[:volumes] || []).collect do |volume|
    volume = { volume: "" } if volume.is_a? String
    volume.map.collect do |name, source|
      _{
        Name name
        Host do
          SourcePath source
        end unless source.empty?
      }
    end
  end.flatten
end

def _ecs_load_balancers(args)
  (args[:load_balancers] || []).collect do |balancer|
    target = _ref_string('target', balancer, 'target group')

    _{
      ContainerName _name("name", balancer)
      ContainerPort balancer[:port] || 80
      LoadBalancerName _name("lb_name", balancer) if target.empty?
      TargetGroupArn target unless target.empty?
    }
  end
end

def _ecs_network(args)
  vpc = args[:vpc] || []
  return vpc if vpc.empty?

  vpc = _ecs_vpc(vpc)

  _{
    AwsvpcConfiguration vpc
  }
end

def _ecs_vpc(args)
  assign_public = _bool('assign_public', args, false)
  security_groups = _ref_array('security_groups', args, 'security group')
  subnets = _ref_array('subnets', args, 'subnets')

  _{
    AssignPublicIp assign_public ? 'ENABLED' : 'DISABLED'
    SecurityGroups security_groups unless security_groups.empty?
    Subnets subnets
  }
end

def _ecs_containers(args)
  (args[:containers] || []).collect.with_index do |container, i|
    container[:name] = "container-#{i + 1}" unless container.key? :name

    command = _array(container[:command] || [])
    cpu = container[:cpu] || 1
    search_domains = _ref_array("search_domains", args)
    servers = _ref_array("servers", args)
    label = container[:label] || {}
    security_options = _array(container[:security_options] || [])
    entry_point = _array(container[:entry_point] || [])
    environment = _pair_name_value(container, "environment")
    extra_hosts = _ecs_extra_hosts(container)
    host = _name("host", container)
    image =
      if container.key? :my_image
        _join([ _account_id,
                        ".dkr.ecr.",
                        _region,
                        ".amazonaws.com/",
                        container[:my_image],
                        ":",
                        container[:my_image_tag] || "latest"
                      ], "")
      else
        container[:image] || "nginx:latest"
       end
    links = _array(container[:links] || [])
    log_config = _ecs_log_configuration(container)
    memory = container[:memory] || 300
    memory_reservation = container[:memory_reservation] || 0
    mount_points = _ecs_mount_points(container)
    port_mappings = _ecs_port_mappings(container)
    ulimits = _ecs_ulimits(container)
    user = container[:user] || ""
    volumes = _ecs_volumes_from(container)
    working = container[:working] || ""

    _{
      Command command unless command.empty?
      Cpu cpu
      DisableNetworking _bool("networking", container, false)
      DnsSearchDomains search_domains unless search_domains.empty?
      DnsServers servers unless servers.empty?
      DockerLabels label unless label.empty?
      DockerSecurityOptions security_options unless security_options.empty?
      EntryPoint entry_point unless entry_point.empty?
      Environment environment unless environment.empty?
      Essential _bool("essential", container, true)
      ExtraHosts extra_hosts unless extra_hosts.empty?
      Hostname host
      Image image
      Links links unless links.empty?
      LogConfiguration log_config unless log_config.empty?
      Memory memory
      MemoryReservation memory_reservation if 0 < memory_reservation
      MountPoints mount_points unless mount_points.empty?
      Name _ref_string("name", container)
      PortMappings port_mappings unless port_mappings.empty?
      Privileged _bool("privileged", container, false)
      ReadonlyRootFilesystem _bool("read_only", container, false)
      Ulimits ulimits unless ulimits.empty?
      User user unless user.empty?
      VolumesFrom volumes unless volumes.empty?
      WorkingDirectory working unless working.empty?
    }
  end
end

def _ecs_extra_hosts(args)
  (args[:extra_hosts] || []).collect do |host|
    _{
      HostName host[:name]
      IpAddress host[:ip]
    }
  end
end

def _ecs_log_configuration(args)
  configuration = args[:log] || []
  return configuration if configuration.empty?

  driver = _valid_values(configuration[:driver],
                         %w( json-file syslog journald gelf fluentd awslogs splunk), "awslogs")
  option = _ecs_to_log_option(configuration)
  _{
    LogDriver driver
    Options option unless option.empty?
  }
end

def _ecs_mount_points(args)
  (args[:mount_points] || []).collect do |point|
    _{
      ContainerPath point[:container]
      SourceVolume point[:source]
      ReadOnly _bool("read_only", point, false)
    }
  end
end

def _ecs_port_mappings(args)
  (args[:port_mappings] || []).collect do |port|
    host = _ref_string_default("host", port)
    _{
      ContainerPort _ref_string("container", port)
      HostPort host unless host.empty?
      Protocol _valid_values(port[:protocol], %w( tcp udp ), 'tcp')
    }
  end
end

def _ecs_ulimits(args)
  (args[:ulimits] || []).collect do |ulimit|
    _{
      HardLimit ulimit[:hard]
      Name _name("name", ulimit)
      SoftLimit ulimit[:hard] || ulimit[:soft]
    }
  end
end

def _ecs_volumes_from(args)
  (args[:volumes_from] || []).collect do |volume|
    _{
      SourceContainer _ref_string("source", volume)
      ReadOnly _bool("read_only", volume, false)
    }
  end
end

def _ecs_deployment(args)
  return "" unless args.key? :deployment

  deployment = args[:deployment]

  _{
    MaximumPercent deployment[:max] || 200
    MinimumHealthyPercent deployment[:min] || 50
  }
end

def _ecs_placement_definition(args, key = 'placement')
  placement = args[key.to_sym] || []
  return placement if placement.empty?

  type = _valid_values(placement[:type], %w( distinctInstance memberOf), "distinctInstance")
  expression = placement[:expression] || ""

  _{
    Type type
    Expression expression unless placement.empty?
  }
end

def _ecs_placement_strategies(args, key = 'placement')
  placement = args[key.to_sym] || []
  return placement if placement.empty?

  type = _valid_values(placement[:type], %w( random spread binpack ), "random")
  field =
    case type
    when "binpack"
      _valid_values(placement[:field], %w( cpu memory ), "cpu")
    when "spread"
      args[:field] || ""
    else
      ""
    end

  _{
    Type type
    Field field unless field.empty?
  }
end
