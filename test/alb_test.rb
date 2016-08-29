require 'abstract_unit'
require 'kumogata/template/alb'

class AlbTest < Minitest::Test
  def test_alb_health_check
    template = <<-EOS
Test _alb_health_check({})
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "interval": 30,
    "path": "/",
    "port": 80,
    "protocol": "HTTP",
    "timeout": 5,
    "healthy": 10,
    "unhealthly": 2
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
