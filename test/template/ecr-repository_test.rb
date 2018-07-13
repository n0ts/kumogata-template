require 'abstract_unit'

class EcrRepositoryTest < Minitest::Test
  def test_normal
    template = <<-EOS
actions = [
  'get download url for layer',
  'batch get image',
  'batch check layer availability',
  'put image',
  'initiate layer upload',
  'upload layer part',
  'complete layer upload',
]
account = { id: 1, name: "test" }
_ecr_repository "test", { policy: { actions: actions, account: account } }
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestEcrRepository": {
    "Type": "AWS::ECR::Repository",
    "Properties": {
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
      },
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

    template = <<-EOS
action = 'get download url for layer'
account = { id: 1, name: "test" }
_ecr_repository "test", { policy: { action: action, account: account } }
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestEcrRepository": {
    "Type": "AWS::ECR::Repository",
    "Properties": {
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
      },
      "RepositoryPolicyText": {
        "Version": "2012-10-17",
        "Statement": [
          {
            "Effect": "Allow",
            "Action": [
              "ecr:GetDownloadUrlForLayer"
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
