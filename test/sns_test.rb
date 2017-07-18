require 'abstract_unit'
require 'kumogata/template/sns'

class SnsTest < Minitest::Test
  def test_sns_subscription
    template = <<-EOS
Test _sns_subscription_list(subscription: [ "test" ])
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": [
    {
      "Endpoint": "test",
      "Protocol": "email"
    }
  ]
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
Test _sns_subscription_list(subscription: [ { protocol: "lambda", endpoint: "test" } ])
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": [
    {
      "Endpoint": {
        "Fn::GetAtt": [
          "Test",
          "Arn"
        ]
      },
      "Protocol": "lambda"
    }
  ]
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
