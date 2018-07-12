#
# Helper - ECR
#
require 'kumogata/template/helper'
require 'kumogata/template/iam'

def _ecr_policy(name, args)
  policy = args[name.to_sym] || {}
  return policy if policy.empty?

  principal = policy[:principal] || {}
  action = policy[:action] || ""
  actions = policy[:actions] || []
  iam_policy = {
    service: "ecr",
    principal: principal,
    no_resource: true,
    aciton: action,
    actions: ations,
  }

  _iam_policy_document("policy", { policy: [ iam_policy ] })
end
