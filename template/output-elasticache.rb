#
# Output elastiacche
#
require 'kumogata/template/helper'

replication = args[:replication] || false
engine = _valid_values(args[:engine], %w( memcached redis ), ELASTICACHE_DEFAULT_ENGINE)

if replication
  if engine == "redis"
    _output "#{args[:name]} cache replication group",
             ref_value: "#{args[:name]} cache replication group"
    _output "#{args[:name]} cache replication group primary address",
            ref_value: [ "#{args[:name]} cache replication group", "PrimaryEndPoint.Address" ]
    _output "#{args[:name]} cache replication group primary port",
             ref_value: [ "#{args[:name]} cache replication group", "PrimaryEndPoint.Port" ]
    _output "#{args[:name]} cache replication group read addresses",
             ref_value: [ "#{args[:name]} cache replication group", "ReadEndPoint.Addresses" ]
    _output "#{args[:name]} cache replication group read ports",
             ref_value: [ "#{args[:name]} cache replication group", "ReadEndPoint.Ports" ]
  end
else
  _output "#{args[:name]} cache cluster", ref_value: "#{args[:name]} cache cluster"
  if engine == "memcached"
    _output "#{args[:name]} cache cluster address",
            ref_value: [ "#{args[:name]} cache cluster", "ConfigurationEndpoint.Address" ]
    _output "#{args[:name]} cache cluster port",
            ref_value: [ "#{args[:name]} cache cluster", "ConfigurationEndpoint.Port" ]
  end
end
