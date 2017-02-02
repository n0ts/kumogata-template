require 'abstract_unit'

class KmsAliasTest < Minitest::Test
  def test_normal
    template = <<-EOS
_kms_alias "test", { "alias": "test", target: "test" }
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestKmsAlias": {
    "Type": "AWS::KMS::Alias",
    "Properties": {
      "AliasName": "test",
      "TargetKeyId": "test"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
