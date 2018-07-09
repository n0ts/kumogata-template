require 'abstract_unit'

class OutputRdsInstanceTest < Minitest::Test
  def test_normal
    template = <<-EOS
_output_rds_instance "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestDbInstance": {
    "Description": "description of TestDbInstance",
    "Value": {
      "Ref": "TestDbInstance"
    }
  },
  "TestDbInstanceAddress": {
    "Description": "description of TestDbInstanceAddress",
    "Value": {
      "Fn::GetAtt": [
        "TestDbInstance",
        "Endpoint.Address"
      ]
    }
  },
  "TestDbInstancePort": {
    "Description": "description of TestDbInstancePort",
    "Value": {
      "Fn::GetAtt": [
        "TestDbInstance",
        "Endpoint.Port"
      ]
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
