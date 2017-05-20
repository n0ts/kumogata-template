require 'aws-sdk'

AWSTemplateFormatVersion "2010-09-09"

Description (<<-EOS).undent
  Kumogata Template - #{NAME} stack
EOS

Metadata do
end

Parameters do
  _parameter "stack name", default: "",
                           description: "the name of this stack"
  _parameter "name", default: "#{NAME}",
                     description: "name of this stack"
  _parameter "service", default: "service",
                        description: "#{NAME} service"
  _parameter "version", default: "0.0.1",
                        description: "#{NAME} version"
end

Mappings do
end

Conditions do
end

Transform do
end

Resources do
  # And more kumogata-template examples at examples/

  # Create a S3 Bucket
  #_s3_bucket "#{NAME}"
end

Outputs do
  # Output S3 Bucket Information
  #_output_s3 "#{NAME}"
end
