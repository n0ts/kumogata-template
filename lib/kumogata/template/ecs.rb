#
# Helper - ECS
#
require 'kumogata/template/helper'

def _ecs_load_balancers(args)
  balancers = args[:load_balancers] || []

  array = []
  balancers.each do |balancer|
    array << _{
      ContainerName balancer[:container_name] || 80
      ContainerPort balancer[:container_port] || 80
      LoadBalancerName balancer[:lb_name] || ""
    }
  end
  array
end

def _ecs_container_definitions(args)
  definitions = args[:container_definitions] || []

  array = []
  definitions.each do |definition|
    command = definition[:command] || []
    entry_point = definition[:entry_point] || []
    environment = definition[:environment] || []
    links = definition[:link] || []
    mount_points = _ecs_mount_points(definition)
    port_mappings =
      if definition.key? :port_mappings
        if definition[:port_mappings].nil?
          []
        else
          _ecs_port_mappings(definition)
        end
      else
        _ecs_port_mappings({ port_mappings: [ { container_port: 80 } ] })
      end
    volumes_from = _ecs_volumes_from(definition)
    array << _{
      Command command unless command.empty?
      Cpu definition[:cpu] || 10
      EntryPoint entry_point unless entry_point.empty?
      Environment environment unless environment.empty?
      Essential _bool("essential", definition, true)
      Image definition[:image]   # repository-url/image:tag
      Links links unless links.empty?
      Memory definition[:memory] || 300  # MiB
      MountPoints mount_points unless mount_points.empty?
      Name _ref_string("name", definition)
      PortMappings port_mappings unless port_mappings.empty?
      VolumesFrom volumes_from unless volumes_from.empty?
    }
  end
  array
end

def _ecs_mount_points(args)
  mount_points = args[:mount_points] || []
  array = []
  mount_points.each do |point|
    array << _{
      ContainerPath point[:container_path]
      SourceVolume point[:source_volume]
      ReadOnly _bool("read_only", point, false)
    }
  end
  array
end

def _ecs_port_mappings(args)
  port_mappings = args[:port_mappings] || []

  array = []
  port_mappings.each do |point|
    host_port = _ref_string("host_port", point, "host port")
    array << _{
      ContainerPort _ref_string("container_port", point, "container port")
      HostPort host_port unless host_port.empty?
    }
  end
  array
end

def _ecs_volumes_from(args)
  volumes_from = args[:volumes_from] || []

  array = []
  volumes_from.each do |volume|
    array << _{
      SourceContainer _ref_string("source", volume)
      ReadOnly _bool("read_only", volume, false)
    }
  end
  array
end

def _ecs_volumes(args)
  volumes = args[:volumes] || []

  array = []
  volumes.each do |volume|
    host = _ecs_volumes_host(volume[:host])
    array << _{
      Name volume[:name]
      Host host unless host.empty?
    }
  end
  array
end

def _ecs_volumes_host(args)
  return {} if args.nil? or !args.key? :source_path

  _{
    SourcePath args[:source_path]
  }
end

def _ecs_deployment(args)
  return "" unless args.key? :max or args.key? :min

  _{
    MaximumPercent args[:max]
    MinimumHealthyPercent args[:min]
  }
end

def _ecs_placement_definition(args)
  return "" unless args.key? :placement

  placement = args[:placement]
  type = _valid_values(placement[:type], %w( distinctInstance memberOf), "distinctInstance")
  expression = placement[:expression] || ""

  _{
    Type type
    Expression expression unless placement.empty?
  }
end

def _ecs_placement_service(args)
  return "" unless args.key? :placement

  placement = args[:placement]
  type = _valid_values(placement[:type], %w( random spread binpack ), "random")
  field =
    case type
    when "binpack"
      _valid_values(args[:field], %w( cpu memory ), "cpu")
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
