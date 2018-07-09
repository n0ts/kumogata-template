#
# EMR cluster resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-emr-cluster.html
#
require 'kumogata/template/helper'
require 'kumogata/template/emr'

name = _resource_name(args[:name], "emr cluster")
applications = _emr_applications(args)
autoscaling =
  if args.key? :autoscaling
    args[:autoscaling] || "EMR_AutoScaling_DefaultRole"
  else
    ""
  end
bootstraps = _emr_bootstraps(args)
configurations = _emr_configurations(args)
instance = _emr_job_flow(args)
job_flow_role = args[:job_flow_role] || "EMR_EC2_DefaultRole"
log = args[:log] || ""
cluster = _name("cluster", args)
release = args[:release] || EMR_DEFAULT_RELEASE
service_role = args[:service_role] || "EMR_DefaultRole"
tags = _tags(args, "cluster")
visible = _bool("visible", args, false)

_(name) do
  Type "AWS::EMR::Cluster"
  Properties do
    #AdditionalInfo
    Applications applications unless applications.empty?
    AutoScalingRole autoscaling unless autoscaling.empty?
    BootstrapActions bootstraps unless bootstraps.empty?
    Configurations configurations unless configurations.empty?
    Instances instance
    JobFlowRole String job_flow_role
    LogUri log unless log.empty?
    Name cluster
    ReleaseLabel release
    ServiceRole service_role
    Tags tags
    VisibleToAllUsers visible
  end
end
