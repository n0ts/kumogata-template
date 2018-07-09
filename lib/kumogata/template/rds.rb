#
# Helper - RDS
#
require 'kumogata/template/helper'

def _rds_to_parameter_charset(charset = 'utf8mb4')
  {
    "character-set-client-handshake": 1,
    "character_set_client": charset,
    "character_set_connection": charset,
    "character_set_database": charset,
    "character_set_results": charset,
    "character_set_server": charset,
  }
end

def _rds_to_event_subscription_source(value)
  case value
  when "instance"
    "db-instance"
  when "parameter", "parameter group"
    "db-parameter-group"
  when "security", "security group"
    "db-security-group"
  when "snapshot"
    "db-snapshot"
  when /db-/
    value
  else
    "db-instance"
  end
end

def _rds_option_group_configurations(args)
  (args[:configurations] || []).collect do |v|
    security_groups = v[:security_groups] || []
    settings = v[:settings] || {}
    port = v[:port] || ""
    vpc_security_groups = v[:security_groups] || []

    _{
      DBSecurityGroupMemberships security_groups unless security_groups.empty?
      OptionName v[:name]
      OptionSettings _{
        Name settings[:name]
        Value settings[:value]
      } unless settings.empty?
      Port port unless port.empty?
      VpcSecurityGroupMemberships vpc_security_groups unless vpc_security_groups.empty?
    }
  end
end
