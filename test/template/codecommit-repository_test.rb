require 'abstract_unit'

class CodecommitRepositoryTest < Minitest::Test
  def test_normal
    template = <<-EOS
_codecommit_repository "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestCodecommitRepository": {
    "Type": "AWS::CodeCommit::Repository",
    "Properties": {
      "RepositoryDescription": "test codecommit repository description",
      "RepositoryName": {
        "Fn::Join": [
          "-",
          [
            {
              "Ref": "Service"
            },
            "test"
          ]
        ]
      }
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
