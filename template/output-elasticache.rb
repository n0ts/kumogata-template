#
# Output elastiacche
#
require 'kumogata/template/helper'

replication = args[:replication] || false
engine = _valid_values(args[:engine], %w( memcached redis ), ELASTICACHE_DEFAULT_ENGINE)

if replication
  if engine == "redis"
    _output "#{args[:name]} cache replication group",
             ref_value: "#{args[:name]} cache replication group",
             export: _export_string(args, "cache replication group")

    _output "#{args[:name]} cache replication group configuration address",
            ref_value: [ "#{args[:name]} cache replication group", "ConfigurationEndPoint.Address" ],
            export: _export_string(args, "cache replication group configuration end point address")
    _output "#{args[:name]} cache replication group configuration port",
            ref_value: [ "#{args[:name]} cache replication group", "ConfigurationEndPoint.Port" ],
            export: _export_string(args, "cache replication group configuration end point port")

    _output "#{args[:name]} cache replication group primary address",
            ref_value: [ "#{args[:name]} cache replication group", "PrimaryEndPoint.Address" ],
            export: _export_string(args, "cache replication group primary end point address")
    _output "#{args[:name]} cache replication group primary port",
             ref_value: [ "#{args[:name]} cache replication group", "PrimaryEndPoint.Port" ],
             export: _export_string(args, "cache replication group primary end point port")

    _output "#{args[:name]} cache replication group read addresses",
             ref_value: [ "#{args[:name]} cache replication group", "ReadEndPoint.Addresses" ],
             export: _export_string(args, "cache replication group read end point addresses")
    _output "#{args[:name]} cache replication group read ports",
             ref_value: [ "#{args[:name]} cache replication group", "ReadEndPoint.Ports" ],
             export: _export_string(args, "cache replication group read end point ports")
  end
else
  _output "#{args[:name]} cache cluster", ref_value: "#{args[:name]} cache cluster"
  if engine == "memcached"
    _output "#{args[:name]} cache cluster address",
            ref_value: [ "#{args[:name]} cache cluster", "ConfigurationEndpoint.Address" ],
            export: _export_string(args, "cache replication group configuration endpoint address")
    _output "#{args[:name]} cache cluster port",
            ref_value: [ "#{args[:name]} cache cluster", "ConfigurationEndpoint.Port" ],
            export: _export_string(args, "cache replication group configuration endpoint port")
  end
end
