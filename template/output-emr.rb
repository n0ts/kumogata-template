#
# output emr
#

_output "#{args[:name]} emr cluster", ref_value: "#{args[:name]} emr cluster"
_output "#{args[:name]} emr cluster master public dns", ref_value: [ "#{args[:name]} emr cluster", "MasterPublicDNS" ]
