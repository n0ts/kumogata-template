require 'abstract_unit'
require 'kumogata/template/const'

class ParameterRdsTest < Minitest::Test
  def test_normal
    values = ''
    RDS_INSTANCE_CLASSES.each_with_index do |v, i|
      values +=<<-EOS
      "#{v}"#{i == (RDS_INSTANCE_CLASSES.size - 1) ? '': ','}
EOS
    end
    template = <<-EOS
_parameter_rds "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestDbInstanceClasses": {
    "Type": "String",
    "Default": "#{RDS_DEFAULT_INSTANCE_CLASS}",
    "AllowedValues": [
#{values.chomp}
    ],
    "Description": "test db instance classes"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
