#
# ECR Repository resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ecr-repository.html
#
require 'kumogata/template/helper'
require 'kumogata/template/ecr'

name = _resource_name(args[:name], "ecr repository")
repo_name = _name("repository", args)
policy = _ecr_policy("policy", args)

_(name) do
  Type "AWS::ECR::Repository"
  Properties do
    RepositoryName repo_name
    RepositoryPolicyText do
      Version "2012-10-17"
      Statement policy
    end unless policy.empty?
  end
end
