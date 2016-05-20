AWSTemplateFormatVersion "2010-09-09"

Description (<<-EOS).undent
  Kumogata Template - #{NAME} stack
EOS

Parameters do
  _parameter "name", default: "#{NAME}",
                     description: "name of this stack"
  _parameter "service", default: "service",
                        description: "#{NAME} service"
  _parameter "version", default: "1.0.0",
                        description: "#{NAME} version"
end

Mappings do
end

Resources do
  _s3_bucket "#{NAME}"
end

Outputs do
  _output_s3 "#{NAME}"
end
