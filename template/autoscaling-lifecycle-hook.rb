#
# Autoscaling LifecycleHook resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-as-lifecyclehook.html
#
require 'kumogata/template/helper'

name = _resource_name(args[:name], "autoscaling lifecycle hook")
autoscaling = _ref_string("autoscaling", args, "autoscaling group")
default = args[:default] || ""
heartbeat = args[:heartbeat] || ""
lifecycle = args[:lifecycle] || "autoscaling::EC2_INSTANCE_TERMINATING"
notification_meta = args[:notificatin_meta] || ""
notification_arn = _ref_string("topic", args, "topic")
role = _ref_attr_string("role", "Arn", args, "role")

_(name) do
  Type "AWS::AutoScaling::LifecycleHook"
  Properties do
    AutoScalingGroupName autoscaling
    DefaultResult default unless default.empty?
    HeartbeatTimeout heartbeat unless heartbeat.empty?
    LifecycleTransition lifecycle
    NotificationMetadata notification_meta unless notification_meta.empty?
    NotificationTargetARN notification_arn
    RoleARN role
  end
end
