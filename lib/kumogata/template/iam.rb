#
# Helper - IAM
#
require 'kumogata/template/helper'
require 'kumogata/template/pinpoint'

def _iam_to_policy(value)
  case value
  when 'admin'
    'AdministratorAccess'
  when 'power'
    'PowerUserAccess'
  when / full/
    #
    "AWSMobileHub_FullAccess"

    #_resource_name
  when /readonly/
    'ReadOnlyAccess'
  when 'database', 'network', 'system'
    "#{value.upcase}Administrator"
  else
    value
  end
end

def _iam_to_condition_s3_bucket_owner_full_control()
  { '=': { 's3:x-amz-acl': 'bucket-owner-full-control' } }
end

def _iam_policies(name, args)
  (args[name.to_sym] || []).collect.with_index do |v, i|
    case v[:policy]
    when 'pinpoint-full'
      v[:document] = _pinpoint_to_iam_full(v[:app])
    end

    v[:name] = "policy-#{i + 1}"
    policy =
    _{
      PolicyDocument do
        Version "2012-10-17"
        Statement _iam_policy_document("document", v)
      end
      PolicyName  _name("policy", v)
    }
  end
end

def _iam_policy_principal(args, key = "principal")
  principal = args[key.to_sym] || {}
  return "" if principal.empty?
  return principal if principal.is_a? String

  if principal.key? :account
    account = principal[:account]
    if account.is_a? Hash
      _{
        AWS _iam_arn("iam", { type: "user", account_id: account[:id], name: account[:name] })
      }
    else
      _{
        AWS account
      }
    end
  elsif principal.key? :accounts
    accounts = principal[:accounts].collect do |v|
      _iam_arn("iam", { type: "user", account_id: v[:id], name: v[:name] })
    end

    _{
      AWS accounts
    }
  elsif principal.key? :federated
    _{
      Federated principal[:federated]
    }
  elsif principal.key? :assumed_role
    assumed_role = principal[:assumed_role]
    _{
      AWS _iam_arn("sts",
                   { type: "assumed-role",
                     account_id: assumed_role[:id], name: assumed_role[:name] })
    }
  elsif principal.key? :service_region
    _{
      Service _sub_service(principal[:service_region])
    }
  elsif principal.key? :services or principal.key? :service
    _{
      Service principal[:services] || principal[:service]
    }
  elsif principal.key? :canonical
    _{
      CanonicalUser principal[:canonical]
    }
  else
    ''
  end
end

def _iam_policy_document(name, args)
  (args[name.to_sym] || []).collect do |v|
    _services =
      if v.key? :service
        [ v[:service] ]
      else
        v[:services] || []
      end
    next if _services.empty?

    _actions =
      if v.key? :action
        [ v[:action] ]
      else
        v[:actions] || [ "*" ]
      end

    actions = []
    _services.each do |s|
      _actions.each do |a|
        actions <<
          unless a[0].match(/^[a-z]/).nil?
            "#{s}:#{_capitalize(a)}"
          else
            "#{s}:#{a}"
          end
      end
    end

    resources = []
    resource =
      if v.key? :resources
        _services.collect{|s| _iam_arn(s, v[:resources]) }.flatten
      elsif v.key? :resource
        _services.collect{|s| _iam_arn(s, v[:resource]) }.flatten
      else
        [ "*" ]
      end
    principal = _iam_policy_principal(v)
    not_principal = _iam_policy_principal(v, "not_principal")

    _{
      Sid v[:sid] if v.key? :sid
      Effect v[:effect] || "Allow"
      NotAction no_action v[:no_action] if v.key? :no_action
      Action actions
      Resource resource unless v.key? :no_resource
      Principal principal unless principal.empty?
      NotPrincipal not_principal unless not_principal.empty?
      Condition _iam_policy_conditions(v[:condition]) if v.key? :condition
    }
  end
end

def _iam_assume_role_policy_document(args)
  cognito = args[:cognito] || false
  aws = args[:aws] || []
  federated =
    if cognito
      "cognito-identity.amazonaws.com"
    else
      args[:federated] || ""
    end
  service =
    if args.key? :services or args.key? :service
      (args[:services] || [ args[:service] ]).collect{|v| "#{v}.#{DOMAIN}" }
    else
      ''
    end
  canonical = args[:canonical] || ""
  action =
    if cognito
      "assume role with web identity"
    else
      args[:action] || "assume role"
    end
  cond_auds = _ref_string_default("cond_auds", args)
  cond_external = _ref_string_default("cond_external", args)
  cond_amr = args[:cond_amr] || ""
  condition =
    unless cond_auds.empty? and cond_external.empty? and cond_amr.empty?
       true
     else
       false
     end

  [
   _{
     Effect "Allow"
     Principal _{
       AWS _iam_arn("iam", aws) unless aws.empty?
       Federated federated unless federated.empty?
       Service service unless service.empty?
       CanonicalUser canonical unless canonical.empty?
     }
     Action [ "sts:#{_capitalize(action)}" ]
     Condition _{
       StringEquals _{
         cognito____identity___amazonaws___com_aud cond_auds unless cond_auds.empty?
         sts_ExternalId cond_external unless cond_external.empty?
       }
       ForAnyValue_StringLike _{
         cognito____identity___amazonaws___com_amr cond_amr unless cond_amr.empty?
       } if cognito
     } if condition
   }
  ]
end

# Amazon Resource Names (ARNs) and AWS Service Namespaces
# https://docs.aws.amazon.com/general/latest/gr/aws-arns-and-namespaces.html
def _iam_arn(service, resource)
  def _convert(args)
    return "" if args.empty?
    return args if args.is_a? String
    result = args.collect do |k, v|
      case k.to_s
      when "ref"
        _{ Ref _resource_name(v) }
      when /ref_(.*)/
        _ref_pseudo($1)
      else
        v
      end
    end
    (args.size == 1) ? result.first : result
  end

  def _value(name, value, default = "*")
    if value.key? "ref_#{name}".to_sym
      { ref_: value["ref_#{name}".to_sym] }
    elsif value.key? "import_#{name}".to_sym
      { import_: value["import_#{name}".to_sym] }
    else
      value[name.to_sym] || default
    end
  end

  arn_prefix = "arn:aws:#{service}"
  resources =
    if resource.is_a? String
      [ { resource: resource } ]
    elsif resource.is_a? Hash
      [ resource ]
    else
      resource
    end

  case service
  when "apigateway"
    resources.each_with_index do |v, i|
      resources[i][:account_id] = false
      resources[i][:values] = [ _value("path", v) ]
    end

  when "execute-api"
    resources.each_with_index do |v, i|
      resources[i][:values] = [ _value("id", v), "/", _value("stage", v), "/",
                                _value("http", v), _value("path", v, "/*") ]
    end

  when "artifact"
    resources.each_with_index do |v, i|
      resources[i][:values] = [ "report-package/", _value("document", v), "/", _value("report", v) ]
    end

  when "autoscaling"
    resources.each_with_index do |v, i|
      type =
        case v[:type]
        when "policy"
          "scalingPolicy"
        else
          "autoScalingGroup"
        end
      values = [ type, ":", _value("id", v), ":autoScalingGroupName/", _value("name", v) ]
      values << _value("sub_name", v) if v[:type] == "policy"
      resources[i][:values] = values
    end

  when "acm"
    resources.each_with_index do |v, i|
      resources[i][:values] = [ "certificate/", _value("id", v) ]
    end

  when "cloudformation"
    resources.each_with_index do |v, i|
      type =
        if v[:type] == "change"
          "changeSet"
        else
          "stack"
        end
      resources[i][:values] = [ type, "/", _value("name", v), "/", _value("id", v) ]
    end

  when "cloudsearch"
    resources.each_with_index{|v, i| resources[i][:values] = [ "domain/", _value("name", v) ] }

  when "cloudtrail"
    resources.each_with_index{|v, i| resources[i][:values] = [ "trail/", _value("name", v) ] }

  when "events"
    resources.each_with_index do |v, i|
      resources[i][:region] = "*"
      resources[i][:account_id] = "*"
      resources[i][:value] = "*"
    end

  when "codebuild"
    resources.each_with_index{|v, i| resources[i][:values] = [ _value("type", v, "project"), "/", _value("name", v) ] }

  when "codecommit"
    resources.each_with_index{|v, i| resources[i][:values] = [ _value("id", v) ] }

  when "codedeploy"
    resources.each_with_index{|v, i| resources[i][:values] = [ _value("type", v), "/", _value("spec", v) ] }

  when "cognito-idp"
    resources.each_with_index{|v, i| resources[i][:values] = [ "userpool/", _value("id", v) ] }

  when "cognito-identity"
    resources.each_with_index{|v, i| resources[i][:values] = [ "identitypool/", _value("id", v) ] }

  when "cognito-sync"
    resources.each_with_index{|v, i| resources[i][:values] = [ "identitypool/", _value("id", v) ] }

  when "config"
    resources.each_with_index{|v, i| resources[i][:values] = [ "config-rule/", _value("name", v) ] }

  when "codepipeline"
    resources.each_with_index{|v, i| resources[i][:values] = [ _value("spec", v) ] }

  when "codestar"
    resources.each_with_index{|v, i| resources[i][:values] = [ _value("spec", v) ] }

  when "directconnect"
    resources.each_with_index{|v, i| resources[i][:values] = [ _value("type", v), "/", _value("id", v) ] }

  when "dynamodb"
    resources.each_with_index{|v, i| resources[i][:values] = [ "table/", _value("name", v) ] }

  when "ec2"
    resources.each_with_index{|v, i| resources[i][:values] = [ _value("type", v), "/", _value("id", v) ] }

  when "ecr"
    resources.each_with_index{|v, i| resources[i][:values] = [ "repository/", _value("name", v) ] }

  when "ecs"
    resources.each_with_index{|v, i| resources[i][:values] = [ _value("type", v), "/", _value("name", v) ] }

  when "elasticbeanstalk"
    resources.each_with_index{|v, i| resources[i][:values] = [ _value("type", v), "/", _value("name", v) ] }

  when "elasticache"
    resources.each_with_index do |v, i|
      type = v[:type] || "cluster"
      resources[i][:values] = [ type, ":", _value("name", v) ]
    end

  when "elasticfilesystem"
    resources.each_with_index{|v, i| resources[i][:values] = [ "file-system/", _value("id", v) ] }

  when "elasticloadbalancing"
    resources.each_with_index do |v, i|
      v[:type] = "loadbalancer" unless v.key? :type
      type =
        if v.key? :elb
          v[:type]
        else
          if v[:type] == "targetgroup"
            v[:type]
          else
            "#{v[:type]}/app"
          end
        end
      values = [ type, "/", _value("name", v) ]
      values << [ "/", _value("id", v) ] unless v.key? :elb
      resources[i][:values] = values
    end

  when "elastictranscoder"
    resources.each_with_index{|v, i| resources[i][:values] = [ _value("resource", v), "/", _value("id", v) ] }

  when "es"
    resources.each_with_index{|v, i| resources[i][:values] = [ "domain/", _value("name", v) ] }

  when "firehose"
    resources.each_with_index{|v, i| resources[i][:values] = [ "deliverystream/", _value("name", v) ] }

  when "glacier"
    resources.each_with_index{|v, i| resources[i][:values] = [ "valuts/", _value("name", v) ] }

  when "health"
    resources.each_with_index do |v, i|
      type = v[:type] || "event"
      resources[i][:account_id] = false if type == "event"
      resources[i][:values] = [ type, "/", _value("id", v) ]
    end

  when "iam"
    resources.each_with_index do |v, i|
      resources[i][:region] = false
      v[:name] =
        if v.key? :type and v[:type] == "policy"
          _iam_to_policy(v[:name])
        else
          v[:name]
        end
      if v.key? :type
        resources[i][:values] = [ _value("type", v), "/", _value("name", v) ]
      else
        resources[i][:value] = "root"
      end
    end

  when "iot"
    resources.each_with_index do |v, i|
      type = v[:type]
      value_key =
        if type == "cert"
          "id"
        else
          "name"
        end
      resources[i][:values] = [ v[:type], "/", _value(value_key, v) ]
    end

  when "kinesis"
    resources.each_with_index{|v, i| resources[i][:values] = [ "stream/", _value("name", v) ] }

  when "kms"
    resources.each_with_index do |v, i|
      type = v[:type] || "key"
      value_key =
        if type == "key"
          "id"
        else
          "alias"
        end
      resources[i][:values] = [ v[:type] || "key", "/", _value(value_key, v) ]
    end

  when "lambda"
    resources.each_with_index do |v, i|
      type = v[:type] || "function"
      values = [ type, ":", _value("name", v) ]
      values << [ ":", _value("alias", v) ] if v.key? :alias
      values << [ ":", _value("id", v) ] if v.key? :id
      resources[i][:values] = values
    end

  when "logs"
    resources.each_with_index do |v, i|
      resources[i][:region] = v[:region] if v.key? :region
      resources[i][:values] = [ _value("type", v), ':', _value("name", v) ]
      resources[i][:values] += [ ':', 'log-stream', ':', _value("stream", v) ] if v.key? :stream
    end

  when "machinelearning"
    resources.each_with_index{|v, i| resources[i][:values] = [ _value("type", v), "/", _value("id", v) ] }

  when "mobilehub"
    resources.each_with_index{|v, i| resources[i][:values] = [ "project/", _value("id", v) ] }

  when "mobiletargeting"
    resources.each_with_index do |v, i|
      resources[i][:region] = AWS_REGION[:virginia]
      resources[i][:values] = (v.key? :reports) ? [ 'reports' ] : [ 'apps', '/',  _value("app", v) ]
      resources[i][:values] += [ '/', 'campaigns', '/', _value("campaigns", v) ] if v.key? :campaigns
      resources[i][:values] += [ '/', 'segments', '/', _value("segments", v) ] if v.key? :segments
    end

  when "organizations"
    resources.each_with_index{|v, i| resources[i][:values] = [ _value("type", v), "/", _value("id", v) ] }

  when "polly"
    resources.each_with_index{|v, i| resources[i][:values] = [ "lexicon/", _value("name", v) ] }

  when "redshift", "rds"
    resources.each_with_index{|v, i| resources[i][:values] = [ _value("type", v), "/", _value("name", v) ] }

  when "route53"
    resources.each_with_index do |v, i|
      resources[i][:account_id] = false
      resources[i][:region] = false
      resources[i][:values] = [ _value("type", v), "/", _value("id", v) ]
    end

  when "s3"
    arn_prefix_s3 = "#{arn_prefix}:::"
    if resource.is_a? String
      return "#{arn_prefix_s3}#{resource}"

    elsif resource.is_a? Hash
      return _join([ arn_prefix_s3, _convert(resource) ], "")

    else
      s3, s3_map = [], []
      resources.each_with_index do |v, i|
        if v.is_a? String
          s3 << v
        elsif v.is_a? Hash
          s3 << _convert(v)
        else
          tmp = [ arn_prefix_s3 ]
          tmp += v.collect{|vv| _convert(vv) }
          s3_map << _{ Fn__Join "", tmp }
        end
      end
      return s3_map unless s3_map.empty?

      if s3.select{|v| v.is_a? Hash }.empty?
        return s3.collect{|v| "#{arn_prefix_s3}#{v}" }
      else
        return _join(s3.insert(0, arn_prefix_s3), "")
      end
    end

  when "ses"
    resources.each_with_index{|v| resources[i][:value] = v }

  when "sns"
    resources.each_with_index do |v, i|
      values = [ _value("name", v) ]
      values << [ ":", _value("id", v) ] if v.key? :id
      resources[i][:values] = values
    end

  when "ssm"
    resources.each_with_index{|v, i| resources[i][:values] = [ _value("type", v), "/", _value("id", v) ] }

  when "sqs"
    resources.each_with_index{|v, i| resources[i][:values] = [ _value("name", v) ] }

  when "states"
    resources.each_with_index{|v, i| resources[i][:values] = [ _value("type", v), ":", _value("name", v) ] }

  when "storagegateway"
    resources.each_with_index{|v, i| resources[i][:values] = [ _value("type", v), "/", _value("name", v) ] }

  when "sts"
    resources.each_with_index do |v, i|
      resources[i][:region] = false
      resources[i][:value] =
        if v.key? :type
          "#{v[:type]}/#{v[:name]}"
        else
          "root"
        end
    end

  when "trustedadvisor"
    resources.each_with_index do |v, i|
      resources[i][:region] = false
      resources[i][:values] = [ "checks/", _value("code", v), "/", _value("id", v) ]
    end

  when "waf"
    resources.each_with_index do |v, i|
      resources[i][:region] = false
      resources[i][:values] = [ _value("type", v), "/", _value("id", v) ]
    end
  end

  _iam_arn_resource(arn_prefix, resources)
end

def _iam_arn_resource(prefix, resource)
  def _arn(arn, value)
    "#{arn}#{value}".include?("${") ? _sub("#{arn}#{value}") : "#{arn}#{value}"
  end

  resources =
    if resource.is_a? String or resource.is_a? Hash
      [ resource ]
    else
      resource
    end
  result = resources.collect do |v|
    region =
      if v.is_a? Hash and v.key? :region
        v[:region]
      else
        _var_pseudo("region")
      end
    account =
      if v.is_a? Hash and v.key? :account_id
        v[:account_id]
      else
        _var_pseudo("account_id")
      end
    arn =
      if account == false
        "#{prefix}:#{region}::"
      elsif region == false
        "#{prefix}::#{account}:"
      else
        "#{prefix}:#{region}:#{account}:"
      end

    if v.is_a? String
      _arn(arn, v)
    else
      if v.key? :value
        _arn(arn, v[:value])
      else
        values = v[:values] || []
        if values.empty?
          _arn(arn, "*:*")
        else
          if values.select{|v| v.is_a? Hash }.empty?
            _arn(arn, values.join(""))
          else
            values.collect!{|vv| (vv.is_a? String) ? vv : _ref_string("", vv) }
            _join([ _arn(arn, ""), values ].flatten, "")
          end
        end
      end
    end
  end
  (result.length == 1) ? result.first : result
end

def _iam_login_profile(args)
  password = args[:password] || ""
  reset_required = _bool("reset_required", args, true)

  _{
    Password password
    PasswordResetRequired reset_required
  }
end

def _iam_managed_policies(args)
  (args[:managed_policies] || []).collect do |v|
    _iam_arn("iam", { account_id: "aws", type: "policy", name: v })
  end
end

def _iam_policy_conditions(args)
  args = [ args ] if args.is_a? Hash

  conditions = {}
  args.each do |v|
    case v
    when 's3 bucket owner full control'
      v = _iam_to_condition_s3_bucket_owner_full_control
    end if v.is_a? String

    v.each_pair do |kk, vv|
      operator =
        case kk.to_s
        when '='
          'Equals'
        when '!='
          'NotEquals'
        when '=='
          'EqualsIgnoreCase'
        when '!=='
          'NotEqualsIgnoreCase'
        when '=~'
          'Like'
        when '!~'
          'NotLike'
        when '<'
          'LessThan'
        when '<='
          'LessThanEquals'
        when '>'
          'GreaterThan'
        when '>='
          'GreaterThanEquals'
        end
      type =
        if vv.key? :type
          case vv[:type]
          when /str/
            'String'
          when /int/
            'Numeric'
          when /date/
            'Date'
          when /bool/
            'Bool'
          when /bin/
            'Binary'
          when /ip/
            'IpAddress'
          when /noip/
            'NotIpAddress'
          when /arn/
            'Arn'
          when /null/, /nil/
            'Null'
          else
            'String'
          end
        else
          'String'
        end
      vv.delete(:type) if vv.key? :type
      operator = '' if type =~ /(Ip|Null)/
      if vv.key? :exists
        exists = 'IfExists'
        vv.delete(:exists)
      end
      value = {}
      vv.each_pair do |kkk, vvv|
        if vvv.is_a? Integer
          type = 'Numeric'
          vvv = vvv.to_s
        elsif vvv.is_a? TrueClass or vvv.is_a? FalseClass
          type = 'Bool'
          operator = ''
          vvv = vvv.to_s
        end
        value[kkk.to_s] = vvv
      end
      conditions["#{type}#{operator}#{exists}"] = value
    end
  end
  conditions
end
