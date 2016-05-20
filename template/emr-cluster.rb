#
# EMR Cluster resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-emr-cluster.html
#
require 'kumogata/template/helper'
require 'kumogata/template/emr'

name = _resource_name(args[:name], "emr cluster")
applications = _emr_applications(args)
bootstraps = _emr_bootstraps(args)
configurations = _emr_configurations(args)
ebs = _emr_ebs(args)
instance = _emr_job_flow(args)
job_flow_role = args[:job_flow_role] || "EMR_EC2_DefaultRole"
log = args[:log] || ""
cluster_name = _ref_name("cluster", args)
release = args[:release] || EMR_DEFAULT_RELEASE
service_role = args[:service_role] || "EMR_DefaultRole"
tags = _tags(args)
visible = _bool("visible", args, false)

_(name) do
  Type "AWS::EMR::Cluster"
  Properties do
    #AdditionalInfo
    Applications applications unless applications.empty?
    BootstrapActions bootstraps unless bootstraps.empty?
    Configurations configurations unless configurations.empty?
    EbsConfiguration ebs unless ebs.empty?
    Instances instance
    JobFlowRole String job_flow_role
    LogUri log unless log.empty?
    Name cluster_name
    ReleaseLabel release
    ServiceRole service_role
    Tags tags
    VisibleToAllUsers visible
  end
end
