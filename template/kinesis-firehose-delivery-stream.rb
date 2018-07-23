#
# Kinesis Firehose Delivery System resource
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-kinesisfirehose-deliverystream.html
#
require 'kumogata/template/helper'
require 'kumogata/template/kinesis'

name = _resource_name(args[:name], 'kinesis firehose delivery stream')
stream_name = _name('stream', args)
stream_type = _kinesis_firehose_to_delivery_stream_type(args[:type])
elasticsearch = _kinesis_firehose_delivery_stream_elasticsearch_destination(args[:es])
extended_s3 = _kinesis_firehose_delivery_stream_extended_s3_destination(args[:extended_s3])
kinesis = _kinesis_firehose_delivery_stream_kinesis_stream_source(args[:kinesis])
redshift = _kinesis_firehose_delivery_stream_redshift_destination(args[:redshift])
s3_dest = _kinesis_firehose_delivery_stream_s3_destnation(args[:s3_dest])
depends = _depends([ { ref_log_stream: 'logs log stream' } ], args)

if stream_type == 'KinesisStreamAsSource'
  elasticsearch = ''
  extended_s3 = ''
  redshift = ''
end

_(name) do
  Type 'AWS::KinesisFirehose::DeliveryStream'
  Properties do
    DeliveryStreamName stream_name
    DeliveryStreamType stream_type
    ElasticsearchDestinationConfiguration elasticsearch unless elasticsearch.empty?
    ExtendedS3DestinationConfiguration extended_s3 unless extended_s3.empty?
    KinesisStreamSourceConfiguration kinesis unless kinesis.empty?
    RedshiftDestinationConfiguration redshift unless redshift.empty?
    S3DestinationConfiguration s3_dest unless s3_dest.empty?
  end
  DependsOn depends unless depends.empty?
end
