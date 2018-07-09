#
# Helper - ECR
#
require 'kumogata/template/helper'
require 'kumogata/template/iam'

def _ecr_policy(name, args)
  policy = args[name.to_sym] || {}
  return policy if policy.empty?

  iam_policy = {
    service: 'ecr',
    no_resource: true,
  }
  iam_policy[:sid] = policy[:sid] if policy.key? :sid
  iam_policy[:principal] = policy[:principal] if policy.key? :principal
  iam_policy[:actions] = policy[:actions] if policy.key? :actions
  iam_policy[:action] = policy[:action] if policy.key? :action

  _iam_policy_document('policy', { policy: [ iam_policy ] })
end
