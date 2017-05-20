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
      PolicyDocument _iam_policy_document("document", v)
      PolicyName v[:name] || _resource_name("policy", i)
    }
  end
  array
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
      if v[:resource].is_a? String
        resource = _iam_arn(service, v[:resource])
      else
        resource = v[:resource].collect{|vv| _iam_arn(service, vv) }
      end
    else
      resource = [ "*" ]
    end

    array << _{
      Sid v[:sid] if v.key? :sid
      Effect v[:effect] || "Allow"
      NotAction no_action v[:no_action] if v.key? :no_action
      Action actions
      Resource resource unless v.key? :no_resource
      Principal v[:principal] if v.key? :principal
      NotPrincipal v[:not_principal] if v.key? :not_principal
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
  arn_prefix = "arn:aws:#{service}"

  case service
  when "s3"
    if resource.is_a? String
      "#{arn_prefix}:::#{resource}"
    else
      resources = [ "#{arn_prefix}:::" ]
      resource.each do |v|
        if v =~ /^Ref_(.*)/
          resources << _ref(_resource_name($1))
        else
          resources << v
        end
      end
      _join(resources, "")
    end

  when "cloudformation"
    if resource == "*"
      resource
    else
      "#{arn_prefix}:#{resource[:region]}:#{resource[:account_id]}:stack/#{resource[:stack]}"
    end

  when "iam"
    if resource.key? :sts
      "arn:aws:sts::#{resource[:account_id]}:#{resource[:type]}/#{resource[:user]}"
    elsif resource.key? :policy
      "arn:aws:iam::aws:policy/#{_iam_to_policy(resource[:policy])}"
    elsif resource.key? :root
      "#{arn_prefix}::#{resource[:account_id]}:root"
    else
      "#{arn_prefix}::#{resource[:account_id]}:#{resource[:type]}/#{resource[:user]}"
    end

  when "elasticloadbalancing"
    "#{arn_prefix}:*:*:loadbalancer/#{resource}"

  when "logs"
    "#{arn_prefix}:*:*:*"

  when "kinesis"
    "#{arn_prefix}:#{resource[:region]}:#{resource[:account_id]}:#{resource[:type]}/#{resource[:name]}"
  end
end

def _iam_s3_bucket_policy(region, bucket, prefix, aws_account_id)
  account_id = ELB_ACCESS_LOG_ACCOUNT_ID[region.to_sym]
  prefix = [ prefix ] if prefix.is_a? String
  resource = prefix.collect{|v| "#{bucket}/#{v}/AWSLogs/#{aws_account_id}/*" }
  [
   {
     service: "s3",
     action: [ "PutObject" ],
     principal: {
       AWS: [ account_id ],
     },
     resource: resource,
   },
  ]
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
