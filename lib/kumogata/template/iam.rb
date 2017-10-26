#
# Helper - IAM
#
require 'kumogata/template/helper'

def _iam_to_policy(value)
  case value
  when 'admin'
    'AdministratorAccess'
  when 'power'
    'PowerUserAccess'
  when 'readonly'
    'ReadOnlyAccess'
  else
    value
  end
end

def _iam_to_policy_condition_operator(value)
  case value
  when "=", "eq"
    value = "string equals"
  when "!=", "ne"
    value = "string not equals"
  end

  if value.include? " "
    value.split(" ").map(&:capitalize).join("")
  else
    value
  end
end

def _iam_to_policy_condition(args)
  condition = {}
  args.each_pair do |k, v|
    key = _iam_to_policy_condition_operator(k.to_s)
    value = {}
    last_key = nil
    v.each do |vv|
      if value.key? last_key
        value[last_key] = vv
      else
        value[vv] = nil
        last_key = vv
      end
    end
    condition[key] = value
  end
  condition
end

def _iam_policies(name, args)
  array = []
  policies = args[name.to_sym] || []
  policies.each_with_index do |v, i|
    array << _{
      PolicyDocument do
        Version "2012-10-17"
        Statement _iam_policy_document("document", v)
      end
      PolicyName v[:name] || _resource_name("policy", i)
    }
  end
  array
end

def _iam_policy_principal(args, key = "principal")
  principal = args[key.to_sym] || {}
  return "" if principal.empty?
  return principal if principal.is_a? String

  if principal.key? :account
    account = principal[:account]
    if account.is_a? Hash
      _{
        AWS _iam_arn("iam", { type: "user", account_id: account[:id], user: account[:name] })
      }
    else
      _{
        AWS account
      }
    end
  elsif principal.key? :accounts
    accounts = []
    principal[:accounts].each do |v|
      accounts << _iam_arn("iam", { type: "user", account_id: v[:id], user: v[:name] })
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
      AWS _iam_arn("iam",
                   { sts: true, type: "assumed-role",
                     account_id: assumed_role[:id], user: assumed_role[:name] })
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
    ""
  end
end

def _iam_policy_document(name, args)
  array = []
  documents = args[name.to_sym] || []

  documents.each do |v|
    service = v[:service] || ""
    action = v[:action] || [ "*" ]
    next if service.empty? or action.empty?

    actions = action.collect{|vv| "#{service}:#{vv}" }
    if v.key? :resource
      resource = _iam_arn(service, v[:resource])
    else
      resource = [ "*" ]
    end
    principal = _iam_policy_principal(v)
    not_principal = _iam_policy_principal(v, "not_principal")

    array << _{
      Sid v[:sid] if v.key? :sid
      Effect v[:effect] || "Allow"
      NotAction no_action v[:no_action] if v.key? :no_action
      Action actions
      Resource resource unless v.key? :no_resource
      Principal principal unless principal.empty?
      NotPrincipal not_principal unless not_principal.empty?
      Condition _iam_to_policy_condition(v[:condition]) if v.key? :condition
    }
  end
  array
end

def _iam_assume_role_policy_document(args)
  aws =
    if args.key? :aws
      _iam_arn("iam", args[:aws])
    else
      ""
    end
  service = args[:service] || ""
  condition =
    if args.key? :external_id
      true
    else
      false
    end
  external_id = args[:external_id] || ""

  [
   _{
     Effect "Allow"
     Principal _{
       AWS aws unless aws.empty?
       Service [ "#{service}.amazonaws.com" ] unless service.empty?
     }
     Action [ "sts:AssumeRole" ]
     Condition _{
       StringEquals _{
         sts_ExternalId external_id unless external_id.empty?
       }
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
    array = []
    args.each_pair do |k, v|
      array <<
        case k.to_s
        when "ref"
          _{ Ref _resource_name(v) }
        when /ref_(.*)/
          _ref_pseudo($1)
        else
          v
        end
    end
    (args.size == 1) ? array.first : array
  end

  def _convert_resource(args)
    (args.size == 1) ? args.first : args
  end

  arn_prefix = "arn:aws:#{service}"
  case service
  when "s3"
    arn_prefix_s3 = "#{arn_prefix}:::"
    if resource.is_a? String
      "#{arn_prefix_s3}#{resource}"

    elsif resource.is_a? Hash
      _join([ arn_prefix_s3, _convert(resource) ], "")

    else
      array, array_map = [], []
      resource.each_with_index do |v, i|
        if v.is_a? String
          array << v
        elsif v.is_a? Hash
          array << _convert(v)
        else
          tmp = [ arn_prefix_s3 ]
          tmp += v.collect{|vv| _convert(vv) }
          array_map << _{ Fn__Join "", tmp }
        end
      end
      return array_map unless array_map.empty?

      if array.select{|v| v.is_a? Hash }.empty?
        array.collect{|v| "#{arn_prefix_s3}#{v}" }
      else
        _join(array.insert(0, arn_prefix_s3), "")
      end
    end

  when "cloudformation"
    if resource == "*"
      resource
    else
      resource = [ resource ] if resource.is_a? Hash
      resource.collect!{|v| "#{arn_prefix}:#{v[:region]}:#{v[:account_id]}:stack/#{v[:stack]}" }
      _convert_resource(resource)
    end

  when "iam"
    resource = [ resource ] if resource.is_a? Hash
    resource.collect! do |v|
      if v.key? :sts
        "arn:aws:sts::#{v[:account_id]}:#{v[:type]}/#{v[:user]}"
      elsif v.key? :policy
        "arn:aws:iam::aws:policy/#{_iam_to_policy(v[:policy])}"
      elsif v.key? :role
        "#{arn_prefix}::#{v[:account_id]}:role/#{v[:role]}"
      elsif v.key? :root
        "#{arn_prefix}::#{v[:account_id]}:root"
      else
        "#{arn_prefix}::#{v[:account_id]}:#{v[:type]}/#{v[:user]}"
      end
    end
    _convert_resource(resource)

  when "elasticloadbalancing"
    resource = [ resource ] if resource.is_a? String
    resource.collect!{|v| "#{arn_prefix}:*:*:loadbalancer/#{v}" }
    _convert_resource(resource)

  when "logs"
    "#{arn_prefix}:*:*:*"

  when "kinesis"
    resource = [ resource ] if resource.is_a? Hash
    resource.collect!{|v| "#{arn_prefix}:#{v[:region]}:#{v[:account_id]}:#{v[:type]}/#{v[:name]}" }
    _convert_resource(resource)

  when "lambda"
    resource = [ resource ] if resource.is_a? Hash
    resource.collect! do |v|
      v[:type] = "function" unless v.key? :type
      "#{arn_prefix}:#{v[:region]}:#{v[:account_id]}:#{v[:type]}:#{v[:name]}"
    end
    _convert_resource(resource)

  when "ses"
    resource = [ resource ] if resource.is_a? String
    resource.collect!{|v| "#{arn_prefix}:#{v}" }
    _convert_resource(resource)
  end
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
  arns = args[:managed_policies]

  array = []
  arns.each do |v|
    array << _iam_arn("iam", { policy: v })
  end
  array
end
