#
# KSM Alias resource type
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-kms-alias.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "kms alias")
alias_name = _name("alias", args)
target = _name("target", args)

_(name) do
  Type "AWS::KMS::Alias"
  Properties do
    AliasName alias_name
    TargetKeyId target
  end
end
