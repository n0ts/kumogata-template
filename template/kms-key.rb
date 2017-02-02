#
# KSM Key resource type
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-kms-key.html
#
require 'kumogata/template/helper'
require 'kumogata/template/iam'

name = _resource_name(args[:name], "kms key")
description = args[:description] || ""
enabled = _bool("enabled", args, true)
rotation = _bool("rotation", args, false)
policy = _iam_policy_document("policy", args)

_(name) do
  Type "AWS::KMS::Key"
  Properties do
    Description description unless description.empty?
    Enabled enabled
    EnableKeyRotation rotation
    KeyPolicy do
      Version "2012-10-17"
      Statement policy
    end
  end
end
