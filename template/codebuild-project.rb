#
# CodeBuild Project resource type
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-codebuild-project.html
#
require 'kumogata/template/helper'
require 'kumogata/template/codebuild'

name = _resource_name(args[:name], "codebuild project")
artifacts = _codebuild_artifacts(args[:artifacts])
description = _ref_string_default("description", args, '', "#{args[:name]} codebuild project description")
encryption = args[:encryption] || ""
environment =_codebuild_environement(args[:environment])
project = _name("project", args)
service = _ref_attr_string("service", "Arn", args, "role")
source = _codebuild_source(args[:source])
tags = _tags(args, "project")
timeout = _valid_numbers(args[:timeout], min = 5, max = 480, 0)

_(name) do
  Type "AWS::CodeBuild::Project"
  Properties do
    Artifacts artifacts
    Description description unless description.empty?
    EncryptionKey encryption unless encryption.empty?
    Environment environment
    Name project
    ServiceRole service
    Source source
    Tags tags
    TimeoutInMinutes timeout unless timeout == 0
  end
end
