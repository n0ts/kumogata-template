#
# Helper - Redshift
#
require 'kumogata/template/helper'

def _redshift_parameters(args)
  (args[:parameters] || []).collect do |v|
    name = v[:name] || ""
    value =
      if name == "wlm_json_configuration"
        v[:value].to_json
      else
        v[:value] || ""
      end
    next if name.empty? or value.empty?

    _{
      ParameterName name
      ParameterValue value
    }
  end
end

def _redshift_logging(args)
  logging = args[:logging] || ""
  return logging if logging.empty?

  bucket = _ref_string("bucket", logging, "bucket")
  key = _ref_string("key", logging, "key")

  _{
    BucketName bucket
    S3KeyPrefix s3_key
  }
end
