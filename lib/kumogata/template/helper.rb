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
  bool = args.key?(name.to_sym) ? args[name.to_sym] : default
  bool.to_s == 'true'
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

def _empty?(value)
  return true if value.nil?
  return false if value.is_a? Integer
  return false if value.is_a? TrueClass or value.is_a? FalseClass

  value.empty?
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

def _real_name(name, args)
  key = _ref_key?(name, args) ? name : "name"
  real_name = _ref_string(key, args)
  real_name = real_name.gsub(" ", "-") if real_name.is_a? String
  real_name =~ /^false/i ? false : real_name
end

def _ref_key?(name, args, ref_name = '')
  return true if args.key? "import_#{name}".to_sym
  return true if args.key? "ref_#{name}".to_sym
  return true unless args[name.to_sym].to_s.empty?
  false
end

def _ref_number(name, args, ref_name = '')
  return _import(args["import_#{name}".to_sym]) if args.key? "import_#{name}".to_sym
  return args[name.to_sym].to_i || nil unless args.key? "ref_#{name}".to_sym

  _ref(_resource_name(args["ref_#{name}".to_sym].to_s, ref_name))
end

def _ref_string(name, args, ref_name = '')
  return _import(args["import_#{name}".to_sym]) if args.key? "import_#{name}".to_sym
  return args[name.to_sym].to_s || '' unless args.key? "ref_#{name}".to_sym

  _ref(_resource_name(args["ref_#{name}".to_sym].to_s, ref_name))
end

def _ref_string_default(name, args, ref_name = '', default = '')
  ref_string = _ref_string(name, args, ref_name)
  ref_string.empty? ? default : ref_string
end

def _ref_array(name, args, ref_name = '')
  return args["import_#{name}".to_sym].collect{|v| _import(v) } if args.key? "import_#{name}".to_sym
  return _array(args[name.to_sym]) || [] unless args.key? "ref_#{name}".to_sym

  array = []
  if args["ref_#{name}".to_sym].is_a? String
    array << _ref_string(name, args, ref_name)
  else
    args["ref_#{name}".to_sym].collect{|v|
      array << _ref(_resource_name(v, ref_name))
    }
  end
  array
end

def _ref_attr_string(name, attr, args, ref_name = '')
  if args.key? "ref_#{name}".to_sym
    _attr_string(args["ref_#{name}".to_sym], attr, ref_name)
  elsif args.key? name.to_sym
    args[name.to_sym]
  else
    ''
  end
end

def _ref_name(name, args, ref_name = '')
  return _ref(_resource_name(args["ref_raw_#{name}".to_sym], ref_name)) if args.key? "ref_raw_#{name}".to_sym
  return args["raw_#{name}".to_sym] if args.key? "raw_#{name}".to_sym
  return _import(args["import_#{name}".to_sym]) if args.key? "import_#{name}".to_sym

  name = _ref_string(name, args, ref_name)
  if name.empty?
    _join([ _ref(_resource_name("service")), _ref(_resource_name("name")) ], "-")
  elsif name.is_a? Hash
    _join([ _ref(_resource_name("service")), name ], "-")
  else
    name.gsub(" ", "-")
  end
end

def _ref_name_default(name, args, ref_name = '')
  return args["raw_#{name}".to_sym] if args.key? "raw_#{name}".to_sym
  name = _ref_string(name, args, ref_name)
  name.empty? ? args[:name] : name.gsub(" ", "-")
end

def _ref_resource_name(args, ref_name = '')
  _ref(_resource_name(args[:name], ref_name))
end

def _ref_arn(service, name)
  _join([ "arn:aws:#{service}:::", _ref(_resource_name(name)) ], ",")
end

def _ref_pseudo(type)
  pseudo =
    case type
    when "account"
      "AccountId"
    when "notification arns"
      "NotificationARNs"
    when "no value"
      "NoValue"
    when "region"
      "Region"
    when "stack id"
      "StackId"
    when "stack name"
      "StackName"
    end
  _ref("AWS::#{pseudo}")
end

def _ref(name)
  _{ Ref name }
end

def _azs(region)
  _{ Fn__GetAZs region }
end

def _attr_string(name, attr, ref_name = '')
  _{ Fn__GetAtt [ _resource_name(name, ref_name), attr ] }
end

def _and(conditions)
  _{ Fn__And conditions }
end

def _equals(value1, value2)
  _{ Fn__Equals [ value1, value2 ] }
end

def _if(name, value_if_true, value_if_false)
  _{ Fn__If [ name, value_if_true, value_if_false ] }
end

def _not(conditions)
  _{ Fn__Not conditions }
end

def _or(conditions)
  _{ Fn__Or conditions }
end

def _condition(condition)
  _{ Condition condition }
end

def _base64(data)
  data  = data.undent if data.is_a? String
  _{ Fn__Base64 data }
end

def _base64_shell(data, shell = "/bin/bash")
  _base64("#!#{shell}\n#{data}\n")
end

def _find_in_map(name, top_level, secondary_level)
  _{ Fn__FindInMap [ name, top_level, secondary_level ] }
end

def _select(index, list)
  _{ Fn__Select [ index.to_s, list ] }
end

def _split(name, delimiter = ",")
  _{
    Fn__Split [ delimiter, name ]
  }
end

def _sub(name)
  _{ Fn__Sub name }
end

def _export_string(args, prefix)
  if args.key? :export and args[:export] == true
    "#{args[:name]}-#{prefix.gsub(' ', '-')}"
  else
    ""
  end
end

def _export(args)
  export = args[:export] || ''
  return '' if export.empty?

  _{
    Name _sub("${AWS::StackName}-#{export.gsub(" ", "-")}")
  }
end

def _join(args, delimiter = ",")
  _{ Fn__Join delimiter, args }
end

def _import(name)
  _{
    Fn__ImportValue _sub(name)
  }
end

def _region
  _ref("AWS::Region")
end

def _tag(args)
  key = args[:key].to_s || ''
  value = args[:value] || ''
  if key =~ /^ref_.*/
    key.gsub!(/^ref_/, '')
    value = _ref(_resource_name(value))
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
            Value _tag_name(args)
          },
          _{
            Key "Service"
            Value _ref(_resource_name("service"))
          },
          _{
            Key "Version"
            Value _ref(_resource_name("version"))
          },
         ]
  args[:tags_append].collect{|k, v| tags << _tag(key: k, value: v) } if args.key? :tags_append
  tags
end

def _tag_name(args)
  return _ref(_resource_name(args["ref_raw_tag_name".to_sym])) if args.key? "ref_raw_tag_name".to_sym
  return args["raw_tag_name".to_sym] if args.key? "raw_tag_name".to_sym

  tag_name = _ref_string("tag_name", args)
  return tag_name unless tag_name.empty?

  tag_name = _ref_string("name", args)
  tag_name = tag_name.gsub(" ", "-") if tag_name.is_a? String
  _join([ _ref(_resource_name(args[:tag_service] || "service")), tag_name ], "-")
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
    _azs(_region)
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

def _timestamp_utc_duration(minute, hour = nil, second = nil)
  duration = "PT"
  duration += "#{hour}H" unless hour.nil?
  duration += "#{minute}M"
  duration += "#{second}S" unless second.nil?
  duration
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
