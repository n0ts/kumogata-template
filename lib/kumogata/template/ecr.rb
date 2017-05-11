#
# Helper - ECR
#
require 'kumogata/template/helper'
require 'kumogata/template/iam'


def _ecr_policy(name, args)
  action = args[name.to_sym][:action] || []
  user = args[name.to_sym][:user] || []
  users = []
  user.each do |v|
    users << _iam_arn("iam", { account_id: v[:id], type: "user", user: v[:name] })
  end
  principal = _{
    AWS users
  }
  policy = {
    service: "ecr",
    action: action,
    principal: principal,
    no_resource: true,
  }
  _iam_policy_document("policy", { policy: [ policy ] })
end
