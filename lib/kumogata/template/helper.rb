#
# Helper
#
require 'date'
require 'kumogata/template/const'

def _resource_name(name, append = nil)
  name = name.to_s
  name += " #{append}" unless append.nil?
  name.split.map(&:capitalize).join(' ').gsub(/[-_#,.]/, '').delete(' ')
end

def _array(args)
  if args.is_a? String
    [ args ]
  elsif args.is_a? Hash
    args.values
  else
    args
  end
end

def _bool(name, args, default = false)
  args.key?(name.to_sym) ? args[name.to_sym].to_s : default.to_s
end

def _integer(name, args, default = 0)
  args.key?(name.to_sym) ? args[name.to_sym].to_i : default
end

def _capitalize(name)
  name.split(' ').map(&:capitalize).join()
end

def _description(name)
  name.gsub("\n", ' ').
    gsub(/\s+/, ' ').gsub(/^\s/, '').gsub(/\s$/, '').
    chomp.slice(0, 1024)
end

def _valid_values(value, values, default = nil)
  return default if value.nil?
  values.collect{|v| return v if v =~ /^#{value}$/i }
  default
end

def _valid_numbers(value, min = 0, max = 0, default = nil)
  return default if value.nil?
  number = value.to_i
  (min <= number and number <= max) ? number : default
end

def _real_name(name)
  name.to_s.gsub(' ', '-')
end

def _ref_string(name, args, ref_name = '')
  return args[name.to_sym].to_s || '' unless args.key? "ref_#{name}".to_sym

  _{ Ref _resource_name(args["ref_#{name}".to_sym].to_s, ref_name) }
end

def _ref_array(name, args, ref_name = '')
  return _array(args[name.to_sym]) || [] unless args.key? "ref_#{name}".to_sym

  array = []
  if args["ref_#{name}".to_sym].is_a? String
    array << _ref_string(name, args, ref_name)
  else
    args["ref_#{name}".to_sym].collect{|v|
      array << _{ Ref _resource_name(v, ref_name) }
    }
  end
  array
end

def _ref_attr_string(name, attr, args, ref_name = '')
  if args.key? "ref_#{name}".to_sym
    _{
      Fn__GetAtt [ _resource_name(args["ref_#{name}".to_sym], ref_name), attr ]
    }
  elsif args.key? name.to_sym
    args[name.to_sym]
  else
    ''
  end
end

def _ref_name(name, args, ref_name = '')
  return args["raw_#{name}".to_sym] if args.key? "raw_#{name}".to_sym
  name = _ref_string(name, args, ref_name)
  if name.empty?
    _{ Fn__Join "-", [ _{ Ref "Service" }, _{ Ref "Name" } ] }
  elsif name.is_a? Hash
    _{ Fn__Join "-", [ _{ Ref "Service" }, name ] }
  else
    name.gsub(' ', '-')
  end
end

def _ref_name_default(name, args, ref_name = '')
  return args["raw_#{name}".to_sym] if args.key? "raw_#{name}".to_sym
  name = _ref_string(name, args, ref_name)
  name.empty? ? args[:name] : name.gsub(' ', '-')
end

def _ref_resource_name(args, ref_name = '')
  _{ Ref _resource_name(args[:name], ref_name) }
end

def _attr_string(name, attr, ref_name = '')
  _{ Fn__GetAtt [ _resource_name(name, ref_name), attr ] }
end

def _find_in_map(name, top_level, secondary_level)
  _{ Fn__FindInMap [ name, top_level, secondary_level ] }
end

def _select(index, list)
  _{ Fn__Select [ index.to_s, list ] }
end

def _tag(args)
  key = args[:key].to_s || ''
  value = args[:value] || ''
  if key =~ /^ref_.*/
    key.gsub!(/^ref_/, '')
    value = _{ Ref _resource_name(value) }
  end

  _{
    Key _resource_name(key)
    Value value
  }
end

def _tags(args)
  tags = [
          _{
            Key "Name"
            Value _tag_name(args[:name])
          },
          _{
            Key "Service"
            Value { Ref _resource_name("service") }
          },
          _{
            Key "Version"
            Value { Ref _resource_name("version") }
          },
         ]
  args[:tags_append].collect{|k, v| tags << _tag(key: k, value: v) } if args.key? :tags_append
  tags
end

def _tag_name(name)
  _{
    Fn__Join [ "-", [ _{ Ref _resource_name("service") }, name.to_s.gsub(' ', '-') ] ]
  }
end

def _availability_zone(args, use_subnet = true)
  zone = args.dup
  zone.delete(:ref_subnet) if use_subnet == false
  if zone.key? :ref_subnet
    _ref_attr_string("subnet", "AvailabilityZone", zone, "subnet")
  elsif  zone.key? :ref_az
    _ref_string("az", zone)
  elsif zone.key? :az
    zone[:az]
  else
    ''
  end
end

def _availability_zones(args, use_subnet = true)
  zone = args.dup
  if use_subnet == false
    zone.delete(:ref_subnet)
    zone.delete(:ref_subnets)
  end
  if zone.key? :ref_subnet
    [ _attr_string(args[:ref_subnet], "AvailabilityZone", "subnet") ]
  elsif zone.key? :ref_subnets
    zone[:ref_subnets].collect{|v| _ref_attr_string("subnet", "AvailabilityZone", { ref_subnet: v }, "subnet") }
  elsif args.key? :ref_azs
    zone[:ref_azs].collect{|v| _ref_string("azs", { ref_azs: v }, "zone") }
  elsif  args.key? :ref_az
    [ _ref_string("az", zone, "zone") ]
  else
    _{ Fn__GetAZs _{ Ref "AWS::Region" } }
  end
end

def _timestamp_utc(time = Time.now, type = nil)
  format =
    case type
    when "cron"
      "%M %H %d %m %w"
    else
      "%Y-%m-%dT%H:%M:%SZ"
    end
  time.utc.strftime(format)
end

def _timestamp_utc_from_string(time, type= nil)
  _timestamp_utc(Time.strptime(time, "%Y-%m-%d %H:%M"), type)
end

def _maintenance_window(service, start_time)
  start_time = start_time.utc
  format = "%a:%H:%M"
  case service
  when "elasticache"
    # 60 min
    end_time = start_time + (60 * 60)
  when "rds"
    # 30 min
    end_time = start_time + (60 * 30)
  when "redshift"
    # 30 min
    end_time = start_time + (60 * 30)
  end
  "#{start_time.strftime(format)}-#{end_time.strftime(format)}"
end

def _window_time(service, start_time)
  start_time = start_time.utc
  format = "%H:%M"
  case service
  when "elasticache"
    # 60 min
    end_time = start_time + (60 * 60)
  when "rds"
    # 30 min
    end_time = start_time + (60 * 30)
  end
  "#{start_time.strftime(format)}-#{end_time.strftime(format)}"
end
