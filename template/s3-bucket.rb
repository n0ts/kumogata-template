#
# S3 Bucket resource
# https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-s3-bucket.html
#
require 'kumogata/template/helper'
require 'kumogata/template/s3'

name = _resource_name(args[:name], "bucket")
access =
  if args.key? :access
    _s3_to_access(args[:access])
  else
    ''
  end
bucket = _name("bucket", args)
cors = _s3_cors(args)
lifecycle = _s3_lifecycle(args)
logging = _s3_logging(args)
notification = _s3_notification(args)
replication = _s3_replication(args)
tags = _tags(args, "bucket")
versioning = _s3_versioning(args)
website = _s3_website(args)
deletion_policy = _s3_to_deletion_policy(args[:deletion_policy])
depends = _depends([ { ref_lambda_permission: 'lambda permission' } ], args)

access = "PublicRead" if !website.empty? and access == ''
access = "Private" if access.empty?

_(name) do
  Type "AWS::S3::Bucket"
  Properties do
    AccessControl access
    BucketName bucket
    CorsConfiguration cors unless cors.empty?
    LifecycleConfiguration lifecycle unless lifecycle.empty?
    LoggingConfiguration logging unless logging.empty?
    NotificationConfiguration notification unless notification.empty?
    ReplicationConfiguration replication unless replication.empty?
    Tags tags
    VersioningConfiguration versioning unless versioning.empty?
    WebsiteConfiguration website unless website.empty?
  end
  DeletionPolicy deletion_policy
  DependsOn depends unless depends.empty?
end
