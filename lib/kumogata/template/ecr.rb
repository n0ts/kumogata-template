#
# Helper - ECR
#
require 'kumogata/template/helper'
require 'kumogata/template/iam'

def _ecr_policy(name, args)
  action = args[name.to_sym][:action] || []
  user = args[name.to_sym][:user] || []
  account = args[name.to_sym][:account]
  principal = { account: account }
  policy = {
    service: "ecr",
    action: action,
    principal: principal,
    no_resource: true,
  }
  _iam_policy_document("policy", { policy: [ policy ] })
end
