#
# IAM access-key resource
# https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-iam-accesskey.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "access key")
serial = args[:serial] || nil
status = _valid_values(args[:status], %w( Active Inactive ), "Active")
user = _ref_string("user", args, "user")

_(name) do
  Type "AWS::IAM::AccessKey"
  Properties do
    Serial serial unless serial.nil?
    Status status
    UserName user
  end
end
