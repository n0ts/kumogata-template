#
# Helper - Kinesis
#
require 'kumogata/template/helper'
require 'kumogata/template/role'

def _kinesis_firehose_to_delivery_stream_role(args)
  role = []
  # TODO add more destination: redshift and elasticsearch service
  KINESIS_FIREHOSE_DELIVERY_STREAM_ROLE.each do |v|
    next if v[:service] == 'lambda' and !args.key? :lambda
    next if v[:service] == 'kms' and !args.key? :key

    _role = { service: v[:service], actions: v[:actions] }
    _role[:resources] = v[:resources].collect do |vv|
      if vv.is_a? String
        if args.key? :bucket
          vv.gsub('%BUCKET_NAME%', args[:bucket])
        elsif args.key? :key
          vv.gsub('%KEY%', args[:key])
        end
      elsif vv.is_a? Hash
        vv.each_pair do |kkk, vvv|
          vv[kkk] = vvv.
            gsub('%STREAM_NAME%', args[:name]).
            gsub('%LOG_GROUP_NAME%', args[:name]).
            gsub('%LOG_STREAM_NAME%', '*')
        end
      end
    end
    _role[:condition] = v[:condition].collect do |vv|
      vv.each_pair do |kkk, vvv|
        # FIXME s3 or ...
        case vvv.first[0]
        when /kms:ViaService/
          vv[kkk][vvv.first[0]] = _sub_service('s3')
        when /aws:s3:arn/
          vv[kkk][vvv.first[0]] = _iam_arn('s3', "#{args[:bucket]}/*")
        end
      end
    end if v.key? :condition
    role << _role
  end
  role
end

def _kinesis_firehose_to_delivery_stream_type(value)
  case value
  when /direct/
    'DirectPut'
  when /kinesis/
    'KinesisStreamAsSource'
  else
    'DirectPut'
  end
end

def _kinesis_firehose_to_elasticsearch_destination(value)
  case value
  when /failed/
    'FailedDocumentsOnly'
  when /all/
    'AllDocuments'
  else
    'FailedDocumentsOnly'
  end
end

def _kinesis_firehose_to_s3_destinaiton_compression(value)
  case value
  when /un/
    'UNCOMPRESSED'
  when 'gzip'
    'GZIP'
  when 'zip'
    'ZIP'
  when 'snappy'
    'Snappy'
  else
    'UNCOMPRESSED'
  end
end

def _kinesis_firehose_delivery_stream_elasticsearch_destination(args)
  return {} if args.nil?

  buffering = _kinesis_firehose_delivery_stream_buffering_hints(args[:buffering_hints])
  cloudwatch = _kinesis_firehose_delivery_stream_cloudwatch_logging(args[:logging])
  domain = _ref_attr_string('domain', 'DomainArn', args, 'elasticsearch domain')
  index_name = args[:index]
  index_rotation = _valid_values(args[:index_rotation],
                                 %w( NoRotation OneHour OneDay OneWeek OneMonth ),
                                 'NoRotation')
  processing = _kinesis_firehose_delivery_stream_processing(args[:processing])
  retry_option = _kinesis_firehose_delivery_stream_elasticsearch_retry(args[:retry])
  role = _ref_attr_string('role', 'Arn', args, 'role')
  s3_backup = _kinesis_firehose_to_elasticsearch_destination(args[:s3_backup])
  s3_dest = _kinesis_firehose_delivery_stream_s3_destnation(args[:s3_dest])
  type = args[:type]

  _{
    BufferingHints buffering
    CloudWatchLoggingOptions cloudwatch unless cloudwatch.empty?
    DomainARN domain
    IndexName index_name
    IndexRotationPeriod index_rotation
    ProcessingConfiguration processing unless processing.empty?
    RetryOptions retries
    RoleARN role
    S3BackupMode s3_backup
    S3Configuration s3_dest
    Type type
  }
end

def _kinesis_firehose_delivery_stream_buffering_hints(args)
  args = { interval: 300, size: 5 } if args.nil?

  _{
    IntervalInSeconds args[:interval]
    SizeInMBs args[:size]
  }
end

def _kinesis_firehose_delivery_stream_cloudwatch_logging(args)
  # FIXME change name by delivery name
  args = { enabled: true, group: '/aws/kinesisfirehorse', stream: 'S3Delivery' } if args.nil?

  enabled = _bool('enabled', args, true)
  group = args[:group]
  stream = args[:stream]

  _{
    Enabled enabled
    LogGroupName group
    LogStreamName stream
  }
end

def _kinesis_firehose_delivery_stream_processing(args)
  return {} if args.nil?

  enabled = _bool('enabled', args, true)
  processors = _kinesis_firehose_delivery_stream_processor(args[:processor])

  _{
    Enabled enabled
    Processors processors
  }
end

def _kinesis_firehose_delivery_stream_processor(args)
  parameters = _kinesis_firehose_delivery_stream_processor_parameters(args[:parameters])

  _{
    Parameters parameters
    Type 'Lambda'
  }
end

def _kinesis_firehose_delivery_stream_processor_parameters(args)
  args.collect do |k, v|
    _{
      ParameterName k
      ParameterValue v
    }
  end
end

def _kinesis_firehose_delivery_stream_retry(args)
  duration = args[:duration] || 300

  _{
    DurationInSeconds duration
  }
end

def _kinesis_firehose_delivery_stream_s3_destnation(args)
  return {} if args.nil?

  bucket = _ref_attr_string('bucket', 'Arn', args, 'bucket')
  buffering = _kinesis_firehose_delivery_stream_buffering_hints(args[:buffering_hints])
  cloudwatch = _kinesis_firehose_delivery_stream_cloudwatch_logging(args[:logging])
  compression = _kinesis_firehose_to_s3_destinaiton_compression(args[:compression])
  encryption = _kinesis_firehose_delivery_stream_encryption(args[:encryption])
  prefix = args[:prefix] || ''
  prefix = "#{prefix}/" if prefix !~ /^.*[-|\/]$/
  role = _ref_attr_string('role', 'Arn', args, 'role')

  _{
    BucketARN bucket
    BufferingHints buffering
    CloudWatchLoggingOptions cloudwatch
    CompressionFormat compression
    EncryptionConfiguration encryption
    Prefix prefix unless prefix.empty?
    RoleARN role
  }
end

def _kinesis_firehose_delivery_stream_encryption(args)
  return _{ NoEncryptionConfig 'NoEncryption' } if args.nil?

  kms = _kinesis_firehose_delivery_stream_kms_encryption(args[:kms])

  _{
    KMSEncryptionConfig kms unless kms.empty?
    NoEncryptionConfig 'NoEncryption' if kms.empty?
  }
end

def _kinesis_firehose_delivery_stream_kms_encryption(args)
  return {} if args.nil?

  kms = _ref_attr_string('kms', 'Arn', args, 'kms key')

  _{
    AWSKMSKeyARN kms
  }
end

def _kinesis_firehose_delivery_stream_kinesis_stream_source(args)
  return {} if args.nil?

  kinesis = _ref_attr_string('stream', 'Arn', args, 'kinesis stream')
  role = _ref_attr_string('role', 'Arn', args, 'role')

  _{
    KinesisStreamARN kinesis
    RoleARN role
  }
end

def _kinesis_firehose_delivery_stream_extended_s3_destination(args)
  return {} if args.nil?

  bucket = _ref_attr_string('bucket', 'Arn', args, 'bucket')
  buffering = _kinesis_firehose_delivery_stream_buffering_hints(args[:buffering_hints])
  cloudwatch = _kinesis_firehose_delivery_stream_cloudwatch_logging(args[:logging])
  compression = _kinesis_firehose_to_s3_destinaiton_compression(args[:compression])
  encryption = _kinesis_firehose_delivery_stream_encryption(args[:encryption])
  prefix = args[:prefix] || ''
  role = _ref_attr_string('role', 'Arn', args, 'role')
  s3_backup = _kinesis_firehose_delivery_stream_s3_destnation(args[:s3_backup])
  s3_backup_mode = _kinesis_firehose_to_elasticsearch_destination(args[:s3_backup_mode])

  _{
    BucketARN bucket
    BufferingHints buffering
    CloudWatchLoggingOptions cloudwatch unless cloudwatch.empty?
    CompressionFormat compression
    EncryptionConfiguration encryption unless encryption.empty?
    Prefix prefix
    ProcessingConfiguration processing unless processing.empty?
    RoleARN role
    S3BackupConfiguration s3_backup unless s3_backup.empty?
    S3BackupMode s3_backup_mode
  }
end

def _kinesis_firehose_delivery_stream_redshift_destination(args)
  return {} if args.nil?

  cloudwatch = _kinesis_firehose_delivery_stream_cloudwatch_logging(args[:logging])
  cluster = _ref_string('cluster', args, 'redshift cluster jdbc url')
  password = _ref_string('password', args, 'redshift cluster master user password')
  processing = _kinesis_firehose_delivery_stream_processing(args[:processing])
  role = _ref_attr_string('role', 'Arn', args, 'role')
  s3 = _kinesis_firehose_delivery_stream_s3_destnation(args[:s3])
  user = _ref_string('user', args, 'redshift cluster master user name')

  _{
    CloudWatchLoggingOptions cloudwatch unless cloudwatch.empty?
    ClusterJDBCURL cluster
    CopyCommand copy
    Password password
    ProcessingConfiguration processing unless processing.empty?
    RoleARN role
    S3Configuration s3
    Username user
  }
end
