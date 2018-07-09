#
# Helper - NLB
#
require 'kumogata/template/helper'

def _nlb_to_lb_cross_zone(value = true)
  {
    "load_balancing.cross_zone.enabled": value
  }
end
