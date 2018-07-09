require 'abstract_unit'

class CognitoUserPoolTest < Minitest::Test
  def test_normal
    template = <<-EOS
_cognito_user_pool "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestUserPool": {
    "Type": "AWS::Cognito::UserPool",
    "Properties": {
      "AutoVerifiedAttributes": [
        "email"
      ],
      "Policies": {
        "PasswordPolicy": {
          "MinimumLength": "6",
          "RequireLowercase": "false",
          "RequireNumbers": "false",
          "RequireSymbols": "false",
          "RequireUppercase": "false"
        }
      },
      "UserPoolName": {
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
      "UserPoolTags": {
        "Name": {
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
        "Service": {
          "Ref": "Service"
        },
        "Version": {
          "Ref": "Version"
        }
      }
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
_cognito_user_pool "test", pool: "test pool"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestUserPool": {
    "Type": "AWS::Cognito::UserPool",
    "Properties": {
      "AutoVerifiedAttributes": [
        "email"
      ],
      "Policies": {
        "PasswordPolicy": {
          "MinimumLength": "6",
          "RequireLowercase": "false",
          "RequireNumbers": "false",
          "RequireSymbols": "false",
          "RequireUppercase": "false"
        }
      },
      "UserPoolName": "test-pool",
      "UserPoolTags": {
        "Name": "test-pool",
        "Service": {
          "Ref": "Service"
        },
        "Version": {
          "Ref": "Version"
        }
      }
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
