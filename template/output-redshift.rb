#
# Output redshift
#
require 'kumogata/template/helper'

_output "#{args[:name]} redshift cluster",
        ref_value: "#{args[:name]} redshift cluster",
        export: _export_string(args, "redshift cluster")
_output "#{args[:name]} redshift cluster address",
        ref_value: [ "#{args[:name]} redshift cluster", "Endpoint.Address" ],
        export: _export_string(args, "redshift cluster endpoint address")
_output "#{args[:name]} redshift cluster port",
        ref_value: [ "#{args[:name]} redshift cluster", "Endpoint.Port" ],
        export: _export_string(args, "redshift cluster endpoint port")

_output "#{args[:name]} redshift cluster jdbc url",
        _join([
               'jdbc:redshift://',
               _ref_attr_string('name', 'Endpoint.Address', args, 'redshift cluster'),
               ':',
               _ref_attr_string('name', 'Endpoint.Port', args, 'redshift cluster'),
               '/',
               _ref_string('db_name', args, 'redshift cluster db name'),
              ], ''),
        export: _export_string(args, 'redshift cluster jdbc url') if args.key? :jdbc_url
