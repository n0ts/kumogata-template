#
# Helper
#
require 'date'
require 'kumogata/template/const'

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

def _pair_name_value(args, name)
  _pair_value(args, name, "name")
end

def _pair_value(args, name, key_prefix = "key")
  return "" unless args.key? name.to_sym

  pair = args[name.to_sym]

  if pair.is_a? Hash
    pair.map.collect do |key, value|
      case value
      when /^_ref_(.*)$/
        value = _ref_pseudo($1)
      when /^_import_(.*)$/
        value = _import($1)
      end

      _{
        Value value
      }.merge({ "#{key_prefix.capitalize}": key.to_s })
    end
  else
    pair.collect do |p|
      p.map.collect do |_, value|
        _{
          Value value
        }
      end
    end
  end
end

def _name(name, args, prefix = "-")
  return _import(args["import_#{name}".to_sym]) if args.key? "import_#{name}".to_sym
  ref_name = _ref_string(name, args)
  if ref_name.empty?
    ref_name_default = _ref_string("name", args)
    _join([
           _ref(_resource_name("service")),
           (ref_name_default.is_a? String) ? ref_name_default.gsub(' ', prefix) : ref_name_default,
          ],
          prefix)
  else
    (ref_name.is_a? String) ? ref_name.gsub(' ', prefix) : ref_name
  end
end

def _resource_name(name, append = nil)
  resource = name.to_s.clone
  resource += " #{append}" unless append.nil?
  resource.gsub(/[^0-9A-Za-z]/, ' ').split(' ').map(&:capitalize).join()
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

def _ref_key?(name, args, ref_name = '', check_name = true)
  return true if args.key? "import_#{name}".to_sym
  return true if args.key? "ref_#{name}".to_sym
  return true if check_name and args.key? name.to_sym
  false
end

def _ref_string(name, args, ref_name = '', append_import_name = '')
  return _import(args["import_#{name}".to_sym], ref_name, append_import_name) if args.key? "import_#{name}".to_sym
  return args[name.to_sym].to_s || '' unless args.key? "ref_#{name}".to_sym

  _ref(_resource_name(args["ref_#{name}".to_sym].to_s, ref_name))
end

def _ref_string_default(name, args, ref_name = '', default = '')
  ref_string = _ref_string(name, args, ref_name)
  ref_string.empty? ? default : ref_string
end

def _ref_array(name, args, ref_name = '', attr_name = '', append_import_name = '')
  if args["import_#{name}".to_sym].is_a? String
      [ _import(name, ref_name, append_import_name) ]
  elsif args["ref_#{name}".to_sym].is_a? String
    if attr_name.empty?
      [ _ref_string(name, args, ref_name) ]
    else
      [ _attr_string(name, attr_name, ref_name) ]
    end
  else
    array = []
    array += args["import_#{name}".to_sym].collect do |v|
      _import(v, ref_name, append_import_name)
    end if args.key? "import_#{name}".to_sym
    array += args["ref_#{name}".to_sym].collect do |v|
      if attr_name.empty?
        _ref(_resource_name(v, ref_name))
      else
        _attr_string(v, attr_name, ref_name)
      end
    end if args.key? "ref_#{name}".to_sym
    array.empty? ? _array(args[name.to_sym] || []) : array
  end
end

def _ref_attr_string(name, attr, args, ref_name = '', append_import_name = '')
  if args.key? "import_#{name}".to_sym
    _import(args["import_#{name}".to_sym], ref_name, append_import_name)
  elsif args.key? "ref_#{name}".to_sym
    _attr_string(args["ref_#{name}".to_sym], attr, ref_name)
  elsif args.key? name.to_sym
    args[name.to_sym]
  else
    ''
  end
end

def _ref_arn(service, name)
  _join([ "arn:aws:#{service}:::", _ref(_resource_name(name)) ], ",")
end

def _ref_pseudo(type)
  _ref("AWS::#{_pseudo(type)}")
end

def _var_pseudo(type)
  "${AWS::#{_pseudo(type)}}"
end

def _pseudo(type)
  case type
  when "account id", "account_id"
    "AccountId"
  when "notification arns", "notification_arns"
    "NotificationARNs"
  when "no value", "no_value"
    "NoValue"
  when "region"
    "Region"
  when "stack id", "stack_id"
    "StackId"
  when "stack name", "stack_name"
    "StackName"
  else
    type
  end
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
  if data.is_a? Array
    _base64(_join(data.insert(0, "#!#{shell}"), "\n"))
  else
    _base64(_join([ "#!#{shell}", data ], "\n"))
  end
end

def _find_in_map(name, top_level, secondary_level)
  _{ Fn__FindInMap [ name, top_level, secondary_level ] }
end

def _select(index, list)
  _{ Fn__Select [ index.to_s, list ] }
end

def _split(name, delimiter = ",")
  _{ Fn__Split [ delimiter, name ] }
end

def _sub(name, mappings = [])
  if mappings.empty?
    _{ Fn__Sub name }
  else
    array = [ name ]
    mappings.each do |mapping|
      mapping.each_pair do |key, value|
        _sub = {}
        _sub.store(_resource_name(key), _ref_string('', { ref_: value }))
        array << _sub
      end
    end
    _{ Fn__Sub array }
  end
end

def _sub_service(service)
  _sub("#{service}.#{_var_pseudo('region')}.#{DOMAIN}")
end

def _export_string(args, prefix)
  return '' unless args.key? :export
  return '' unless args[:export] == true

  export = args[:name]
  export += "-#{args[:resource]}" if args.key? :resource
  export += "-#{prefix}" unless prefix.empty?
  export.gsub(/(\s|_)/, '-')
end

def _export(args)
  export = args[:export] || ''
  return '' if export.empty?

  export = "#{export}-#{args[:resource]}" if args.key? :resource

  _{ Name _sub("${AWS::StackName}-#{export.gsub(/(\s|_)/, '-')}") }
end

def _depends(keys, args)
  return '' if keys.emtpy?

  depends =
     if args.key? :depends
       args[:depends].collect{|v| _resource_name(v) }
     else
       []
     end

  keys.each do |v|
    if v.is_a? String
      depends << _resource_name(args[v.to_sym]) if args.key? v.to_sym
    else
      v.each_pair do |kk, vv|
        depends << _resource_name(args[kk.to_sym], vv) if args.key? kk.to_sym
      end
    end
  end

  depends
end

def _join(args, delimiter = ",")
  _{ Fn__Join delimiter, args }
end

def _import(name, ref_name = '', append_import_name = '')
  import = name
  import += "-#{ref_name}" unless ref_name.empty?
  import += "-#{append_import_name}" unless append_import_name.empty?
  _{ Fn__ImportValue _sub(import.gsub(/(\s|_)/, '-')) }
end

def _region
  _ref_pseudo("region")
end

def _account_id
  _ref_pseudo("account id")
end

def _tag(args)
  key = args[:key].to_s || ''
  value = args[:value] || ''
  is_ref = (key =~ /^ref_.*/) ? true : false
  _{
    Key _resource_name(key.gsub(/^ref_/, ''))
    Value is_ref ? _ref(_resource_name(value)) : value
  }
end

def _tags(args, tag_name = "tag_name")
  tags = [
          _{
            Key "Name"
            Value _name(tag_name, args)
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
  args[:tags_append].collect{|k, v| tags << _tag(key: k, value: v.gsub(" ", "-")) } if args.key? :tags_append
  tags
end

def _tags_string(args, tag_name = "tag_name")
  tags = {}
  _tags(args, tag_name).collect{|v| tags[v['Key']] = v['Value'] }
  tags
end

def _var(value)
  "${#{value}}"
end

def _availability_zone(args, use_subnet = true, prefix = "zone name")
  zone = args.clone
  zone.delete(:ref_subnet) if use_subnet == false
  if zone.key? :ref_subnet
    _ref_attr_string("subnet", "AvailabilityZone", zone, "subnet")
  else
    _ref_string("az", zone, prefix)
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

def _timestamp_utc(time = Time.now, type = '')
  format =
    case type
    when "cron"
      "%M %H %d %m %w"
    else
      "%Y-%m-%dT%H:%M:%SZ"
    end
  time.utc.strftime(format)
end

def _timestamp_utc_from_string(time, type = '')
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
