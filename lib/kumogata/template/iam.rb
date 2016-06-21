#
# Helper - IAM
#
require 'kumogata/template/helper'

def _iam_policies(name, args)
  array = []
  policies = args["#{name}".to_sym] || []
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
  documents = args["#{name}".to_sym] || []

  documents.each do |v|
    service = v[:service] || ""
    action = v[:action] || [ "*" ]
    next if service.empty? or action.empty?

    actions = action.collect{|v| "#{service}:#{v}" }
    if v.key? :resource
      if v[:resource].is_a? String
        resource = _iam_arn(service, v[:resource])
      else
        resource = v[:resource].collect{|v| _iam_arn(service, v) }
      end
    else
      resource = [ "*" ]
    end

    array << _{
      Effect v[:effect] || "Allow"
      Action actions
      Resource resource
      Principal v[:principal] if v.key? :principal
    }
  end
  array
end

def _iam_assume_role_policy_document(service)
  [
   _{
     Effect "Allow"
     Principal _{ Service [ "#{service}.amazonaws.com" ] }
     Action [ "sts:AssumeRole" ]
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
          resources << _{ Ref _resource_name($1) }
        else
          resources << v
        end
      end
      _{ Fn__Join "", resources }
    end

  when "cloudformation"
    if resource == "*"
      resource
    else
      "#{arn_prefix}:#{resource[:region]}:#{resource[:account_id]}:stack/#{resource[:stack]}"
    end

  when "iam"
    if resource.key? :sts
      "arn:aws:sts::#{account_id}:#{resource[:type]}/#{resource[:user]}"
    else
      "#{arn_prefix}::#{account_id}:#{resource[:type]}/#{resource[:user]}"
    end

  when "elasticloadbalancing"
    "#{arn_prefix}:*:*:loadbalancer/#{resource}"

  when "logs"
    "#{arn_prefix}:*:*:*"
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
       "AWS": [ account_id ],
     },
     resource: resource,
   },
  ]
end
