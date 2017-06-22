require 'abstract_unit'
require 'kumogata/template/iam'

class IamTest < Minitest::Test
  def test_iam_to_policy_condition
    template = <<-EOS
condition = { "=": [ "s3:x-amz-acl", "bucket-owner-full-control" ] }
Test _iam_to_policy_condition(condition)
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "StringEquals": {
      "s3:x-amz-acl": "bucket-owner-full-control"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
condition = {
  "=": [ "aws:UserAgent", "Example Corp Java Client" ],
  "date greater than": [ "aws:CurrentTime", "2013-08-16T12:00:00Z" ],
  "numeric less than equals": [ "s3:max-keys", "10" ],
  "ip address": [ "aws:SourceIp", ["192.0.2.0/24", "203.0.113.0/24"] ],
}
Test _iam_to_policy_condition(condition)
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "StringEquals": {
      "aws:UserAgent": "Example Corp Java Client"
    },
    "DateGreaterThan": {
      "aws:CurrentTime": "2013-08-16T12:00:00Z"
    },
    "NumericLessThanEquals": {
      "s3:max-keys": "10"
    },
    "IpAddress": {
      "aws:SourceIp": [
        "192.0.2.0/24",
        "203.0.113.0/24"
      ]
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_iam_policies
    template = <<-EOS
Policies _iam_policies "test", test: [ { document: [ { service: "s3" } ] } ]
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Policies": [
    {
      "PolicyDocument": {
        "Version": "2012-10-17",
        "Statement": [
          {
            "Effect": "Allow",
            "Action": [
              "s3:*"
            ],
            "Resource": [
              "*"
            ]
          }
        ]
      },
      "PolicyName": "Policy0"
    }
  ]
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_iam_policy_principal
    template = <<-EOS
Test _iam_policy_principal principal: { account: 1 }
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "AWS": "1"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
Test _iam_policy_principal principal: { account: { id: 1, name: "test" } }
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "AWS": "arn:aws:iam::1:user/test"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
Test _iam_policy_principal principal: { accounts: [ { id: 1, name: "test" } ] }
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "AWS": [
      "arn:aws:iam::1:user/test"
    ]
  }
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
Test _iam_policy_principal principal: { federated: "test" }
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Federated": "test"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
Test _iam_policy_principal principal: { assumed_role: { id: 1, name: "test/test" } }
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "AWS": "arn:aws:sts::1:assumed-role/test/test"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template

     template = <<-EOS
Test _iam_policy_principal principal: { service: "test" }
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Service": "test"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_iam_policy_document
    template = <<-EOS
PolicyDocument _iam_policy_document "test", test: [ { service: "s3" } ]
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "PolicyDocument": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
PolicyDocument _iam_policy_document "test", test: [ { service: "s3", sid: "test" } ]
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "PolicyDocument": [
    {
      "Sid": "test",
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
condition = { "=": [ "s3:x-amz-acl", "bucket-owner-full-control" ] }
PolicyDocument _iam_policy_document "test", test: [ { service: "s3", sid: "test", condition: condition } ]
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "PolicyDocument": [
    {
      "Sid": "test",
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "*"
      ],
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      }
    }
  ]
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_iam_assume_role_policy_document
    template = <<-EOS
Statement _iam_assume_role_policy_document({ service: "ec2" })
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "ec2.amazonaws.com"
        ]
      },
      "Action": [
        "sts:AssumeRole"
      ]
    }
  ]
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_iam_arn
    template = <<-EOS
arn _iam_arn("s3", "test")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "arn": "arn:aws:s3:::test"
}
  EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
arn _iam_arn("s3", { ref: "test" })
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "arn": {
    "Fn::Join": [
      "",
      [
        "arn:aws:s3:::",
        {
          "Ref": "Test"
        }
      ]
    ]
  }
}
  EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
arn _iam_arn("s3", [ "test1", "test2" ])
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "arn": [
    "arn:aws:s3:::test1",
    "arn:aws:s3:::test2"
  ]
}
  EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
arn _iam_arn("s3", [ { ref: "test" }, { ref_account: true }, "/*" ])
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "arn": {
    "Fn::Join": [
      "",
      [
        "arn:aws:s3:::",
        {
          "Ref": "Test"
        },
        {
          "Ref": "AWS::AccountId"
        },
        "/*"
      ]
    ]
  }
}
  EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
test1 = [ { ref: "test1" }, { ref_account: true }, "/*" ]
test2 = [ { ref: "test2" }, { ref_account: true }, "/*" ]
arn _iam_arn("s3", [ test1, test2 ])
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "arn": [
    {
      "Fn::Join": [
        "",
        [
          "arn:aws:s3:::",
          {
            "Ref": "Test1"
          },
          {
            "Ref": "AWS::AccountId"
          },
          "/*"
        ]
      ]
    },
    {
      "Fn::Join": [
        "",
        [
          "arn:aws:s3:::",
          {
            "Ref": "Test2"
          },
          {
            "Ref": "AWS::AccountId"
          },
          "/*"
        ]
      ]
    }
  ]
}
  EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_iam_login_profile
    template = <<-EOS
profile _iam_login_profile(password: "test")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "profile": {
    "Password": "test",
    "PasswordResetRequired": "true"
  }
}
  EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_iam_managed_policies
    template = <<-EOS
managed _iam_managed_policies(managed_policies: %w( admin ))
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "managed": [
    "arn:aws:iam::aws:policy/AdministratorAccess"
  ]
}
  EOS
    assert_equal exp_template.chomp, act_template
  end
end
