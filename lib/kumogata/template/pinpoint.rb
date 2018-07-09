#
# Helper - Pinpoint
#
require 'kumogata/template/helper'
require 'kumogata/template/role'

def _pinpoint_to_iam_readonly(app)
  [
    {
      service: 'mobiletargeting',
      actions: [
                'get *',
               ],
      resource: [
                 { app: app },
                 { app: "#{app}/*" },
                ],
    },
    {
      service: 'mobiletargeting',
      actions: [
                'get reports',
               ],
      resource: [
                 { reports: true },
                ],
    },
  ]
end

def _pinpoint_to_iam_full(app)
  [
    {
      service: 'mobiletargeting',
      actions: [
                'delete *',
                'get *',
                'update *',
               ],
      resource: [
                 { app: app },
                 { app: "#{app}/*" },
                ],
    },
    {
      service: 'mobiletargeting',
      actions: [
                'get reports',
               ],
      resource: [
                 { reports: true },
                ],
    },
  ]
end

def _pinpoint_to_kinesis_stream_role(args)
  role = []
  PINPOINT_KINESIS_STREAM_ROLE.each do |v|
    _role = { service: v[:service], actions: v[:actions] }
    _role[:resources] = v[:resources].collect do |vv|
      vv.each_pair do |kkk, vvv|
        vv[kkk] = vvv.gsub(/%KINESIS_STREAM_NAME%/, args[:name])
      end
    end
    role << _role
  end
  role
end

def _pinpoint_to_kinesis_firehose_delivery_stream_role(args)
  role = []
  PINPOINT_KINESIS_FIREHOSE_DELIVERY_STREAM_ROLE.each do |v|
    _role = { service: v[:service], actions: v[:actions] }
    _role[:resources] = v[:resources].collect do |vv|
      vv.each_pair do |kkk, vvv|
        vv[kkk] = vvv.gsub(/%FIREHOSE_DELIVERY_STREAM_NAME%/, args[:name])
      end
    end
    role << _role
  end
  role
end
