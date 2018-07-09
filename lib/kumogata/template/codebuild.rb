#
# Helper - CodeBuild
#
require 'kumogata/template/helper'

def _codebuild_to_compute(value)
  case value
  when "small"
    "BUILD_GENERAL1_SMALL"
  when "medium"
    "BUILD_GENERAL1_MEDIUM"
  when "large"
    "BUILD_GENERAL1_LARGE"
  else
    "BUILD_GENERAL1_MEDIUM"
  end
end

def _codebuild_source_type(value)
  case value
  when "codecommit", "commit"
    "CODECOMMIT"
  when "codepipeline", "pipeline"
    "CODEPIPELINE"
  when "github", "gh"
    "GITHUB"
  when "s3"
    "S3"
  end
end


def _codebuild_artifacts(args)
  name = args[:name] || ""
  ns = args[:ns] || ""
  packaging = args[:packaging] || ""
  path = args[:path] || ""
  type = _valid_values(args[:type], %w( codepipeline no_artifacts s3 ), "no_artifacts")

  _{
    Location location if type != "codepipeline" and type != "no_artifacts"
    Name name if type != "codepipeline" and type != "no_artifacts"
    NamespaceType ns if type != "codepipeline" and type != "no_artifacts"
    Packaging packaging if type != "codepipeline" and type != "no_artifacts"
    Path path unless path.empty?
    Type type
  }
end

def _codebuild_environement(args)
  compute = _codebuild_to_compute(args[:compute])
  env_hash = _codebuild_environement_hash(args[:env])
  image = args[:image]

  _{
    ComputeType compute
    EnvironmentVariables env_hash
    Image image
    Type "LINUX_CONTAINER"
  }
end

def _codebuild_environement_hash(args)
  (args || {}).collect do |name, value|
    _{
      Name name
      Value value
    }
  end
end

def _codebuild_source(args)
  build = args[:build] || ""
  location = args[:location] || ""
  type = _codebuild_source_type(args[:type])

  _{
    BuildSpec build unless build.empty?
    Location location unless type == "CODEPIPELINE"
    Type type
  }
end
