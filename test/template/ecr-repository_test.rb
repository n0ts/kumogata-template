require 'abstract_unit'

class EcrRepositoryTest < Minitest::Test
  def test_normal
    template = <<-EOS
action = %w(
  GetDownloadUrlForLayer
  BatchGetImage
  BatchCheckLayerAvailability
  PutImage
  InitiateLayerUpload
  UploadLayerPart
  CompleteLayerUpload
)
account = { id: 1, name: "test" }
_ecr_repository "test", { policy: { action: action, account: account } }
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestEcrRepository": {
    "Type": "AWS::ECR::Repository",
    "Properties": {
      "RepositoryName": "test",
      "RepositoryPolicyText": {
        "Version": "2012-10-17",
        "Statement": [
          {
            "Effect": "Allow",
            "Action": [
              "ecr:GetDownloadUrlForLayer",
              "ecr:BatchGetImage",
              "ecr:BatchCheckLayerAvailability",
              "ecr:PutImage",
              "ecr:InitiateLayerUpload",
              "ecr:UploadLayerPart",
              "ecr:CompleteLayerUpload"
            ],
            "Principal": {
              "AWS": "arn:aws:iam::1:user/test"
            }
          }
        ]
      }
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
