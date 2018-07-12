#
# RDS EventSubscription resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-rds-eventsubscription.html
#
require 'kumogata/template/helper'
require 'kumogata/template/rds'

name = _resource_name(args[:name], "event subscription")
enabled = _bool("enabled", args, true)
event_categories = args[:categories] ||
  %w( availability backup configuration\ change creation deletion
      failover failure low\ storage maintenance notification
      read\ replica recovery restoration )
sns = _ref_attr_string("sns", "Arn", args, "role")
sns = _ref_string("sns_arn", args) if sns.empty?
sources = _ref_array("sources", args, "db instance")
source_type = _rds_to_event_subscription_source(args[:source_type])
source_prefix =
  case source_type
  when "db-instance"
    "db instance"
  when "db-parameter-group"
    "db parameter group"
  when "db-security-group"
    "security group"
  when "db-snapshot"
    ""
  end
sources = _ref_array("sources", args, source_prefix)

_(name) do
  Type "AWS::RDS::EventSubscription"
  Properties do
    Enabled enabled
    EventCategories event_categories
    SnsTopicArn sns
    SourceIds sources
    SourceType source_type
  end
end
