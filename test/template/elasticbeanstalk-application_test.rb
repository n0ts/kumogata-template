require 'abstract_unit'

class ElasticbeanstalkApplicationTest < Minitest::Test
  def test_normal
    template = <<-EOS
_elasticbeanstalk_application "test", application: "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestElasticbeanstalkApplication": {
    "Type": "AWS::ElasticBeanstalk::Application",
    "Properties": {
      "ApplicationName": "test",
      "Description": "test elasticbeanstalk application description"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
