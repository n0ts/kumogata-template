#
# EMR Step
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-emr-step.html
#
require 'kumogata/template/helper'
require 'kumogata/template/emr'

name = _resource_name(args[:name], "emr step")
action = _valid_values(args[:action], %w( continue continue_and_wait ), "continue")
hadoop = _emr_hadoop_jar_step_config(args)
cluster = _ref_string("cluster", args, "emr cluster")
step = _name("step", args)

_(name) do
  Type "AWS::EMR::Step"
  Properties do
    ActionOnFailure action.upcase
    HadoopJarStep hadoop
    JobFlowId cluster
    Name step
  end
end
