#
# IAM UserToGroupAddition
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-iam-addusertogroup.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "user to group addition")
group = _ref_string("group", args)
users = _ref_array("users", args)

_(name) do
  Type "AWS::IAM::UserToGroupAddition"
  Properties do
    GroupName group
    Users users
  end
end
