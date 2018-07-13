require 'abstract_unit'
require 'kumogata/template/iam'

class IamTest < Minitest::Test
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
      "PolicyName": {
        "Fn::Join": [
          "-",
          [
            {
              "Ref": "Service"
            },
            "policy-1"
          ]
        ]
      }
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
PolicyDocument _iam_policy_document "test", test: [ { service: "s3", action: "put object" } ]
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "PolicyDocument": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject"
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
PolicyDocument _iam_policy_document "test", test: [ { service: "s3", action: "PutObject" } ]
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "PolicyDocument": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject"
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
PolicyDocument _iam_policy_document "test", test: [ { services: [ "s3", "ec2" ] } ]
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "PolicyDocument": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:*",
        "ec2:*"
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
PolicyDocument _iam_policy_document "test", test: [ { service: "s3", actions: [ "get object *", "put object" ] } ]
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "PolicyDocument": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject*",
        "s3:PutObject"
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
PolicyDocument _iam_policy_document "test", test: [ { service: "s3", actions: [ "GetObject*", "PutObject" ] } ]
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "PolicyDocument": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject*",
        "s3:PutObject"
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
PolicyDocument _iam_policy_document "test", test: [ { service: "s3", resource: "test" } ]
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
        "arn:aws:s3:::test"
      ]
    }
  ]
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
condition = { '=': { 's3:x-amz-acl': "bucket-owner-full-control" } }
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
Statement _iam_assume_role_policy_document({ aws: [ { account_id: 123, root: true } ] })
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::123:root"
      },
      "Action": [
        "sts:AssumeRole"
      ]
    }
  ]
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
Statement _iam_assume_role_policy_document({ federated: "test" })
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "test"
      },
      "Action": [
        "sts:AssumeRole"
      ]
    }
  ]
}
    EOS
    assert_equal exp_template.chomp, act_template

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

    template = <<-EOS
Statement _iam_assume_role_policy_document({ cognito: true, cond_auds: "test", cond_amr: "test" })
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "cognito-identity.amazonaws.com"
      },
      "Action": [
        "sts:AssumeRoleWithWebIdentity"
      ],
      "Condition": {
        "StringEquals": {
          "cognito-identity.amazonaws.com:aud": "test"
        },
        "ForAnyValue:StringLike": {
          "cognito-identity.amazonaws.com:amr": "test"
        }
      }
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
arn _iam_arn("s3", [ { ref: "test" }, { ref_account_id: true }, "/*" ])
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
test1 = [ { ref: "test1" }, { ref_account_id: true }, "/*" ]
test2 = [ { ref: "test2" }, { ref_account_id: true }, "/*" ]
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

    template = <<-EOS
arn _iam_arn("apigateway", { path: "teste:testp/tests" })
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "arn": {
    "Fn::Sub": "arn:aws:apigateway:${AWS::Region}::teste:testp/tests"
  }
}
  EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
arn _iam_arn("execute-api", { id: "test" })
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "arn": {
    "Fn::Sub": "arn:aws:execute-api:${AWS::Region}:${AWS::AccountId}:test/*/*/*"
  }
}
  EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
arn _iam_arn("execute-api", { id: "test", region: "testr", account_id: "testa" })
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "arn": "arn:aws:execute-api:testr:testa:test/*/*/*"
}
  EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_iam_arn_resource
    template = <<-EOS
arn _iam_arn_resource("arn:aws:s3", [ "test" ])
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "arn": {
    "Fn::Sub": "arn:aws:s3:${AWS::Region}:${AWS::AccountId}:test"
  }
}
  EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
arn _iam_arn_resource("arn:aws:s3", { account_id: "testa", region: "testr", value: "test" })
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "arn": "arn:aws:s3:testr:testa:test"
}
  EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
arn _iam_arn_resource("arn:aws:s3", { account_id: "testa", region: false, value: "test" })
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "arn": "arn:aws:s3::testa:test"
}
  EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
values = [ "*/", { ref_: "test" }, "/*" ]
arn _iam_arn_resource("arn:aws:s3", { account_id: false, region: "testr", values: values })
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "arn": {
    "Fn::Join": [
      "",
      [
        "arn:aws:s3:testr::",
        "*/",
        {
          "Ref": "Test"
        },
        "/*"
      ]
    ]
  }
}
  EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
values = [ { import_: "test" }, "/*/*" ]
arn _iam_arn_resource("arn:aws:s3", { account_id: false, region: "testr", values: values })
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "arn": {
    "Fn::Join": [
      "",
      [
        "arn:aws:s3:testr::",
        {
          "Fn::ImportValue": {
            "Fn::Sub": "test"
          }
        },
        "/*/*"
      ]
    ]
  }
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

  def test_iam_policy_conditions
    # {"StringEquals": {"aws:UserAgent": "Example Corp Java Client"}}
    template = <<-EOS
conds = [
  { '=': { 'aws:UserAgent': 'Example Corp Java Client' } },
]
Condition _iam_policy_conditions(conds)
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Condition": {
    "StringEquals": {
      "aws:UserAgent": "Example Corp Java Client"
    }
  }
}
  EOS
    assert_equal exp_template.chomp, act_template

    # {"StringLike": {"s3:prefix": [
    #    "",
    #    "home/",
    #    "home/${aws:username}/"
    #  ]}}
    template = <<-EOS
conds = [
  { '=~': { 's3:prefix': [ "", "home/", "home/${aws:username}/" ] } }
]
Condition _iam_policy_conditions(conds)
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Condition": {
    "StringLike": {
      "s3:prefix": [
        "",
        "home/",
        "home/${aws:username}/"
      ]
    }
  }
}
  EOS
    assert_equal exp_template.chomp, act_template

    # {"NumericLessThanEquals": {"s3:max-keys": "10"}}
    template = <<-EOS
conds = [
  { '<=': { 's3:max-keys': 10 } }
]
Condition _iam_policy_conditions(conds)
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Condition": {
    "NumericLessThanEquals": {
      "s3:max-keys": "10"
    }
  }
}
  EOS
    assert_equal exp_template.chomp, act_template

    # {"DateLessThan": {"aws:CurrentTime": "2013-06-30T00:00:00Z"}}
    template = <<-EOS
conds = [
  { '<': { type: 'date', 'aws:CurrentTime': '2013-06-30T00:00:00Z' } }
]
Condition _iam_policy_conditions(conds)
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Condition": {
    "DateLessThan": {
      "aws:CurrentTime": "2013-06-30T00:00:00Z"
    }
  }
}
  EOS
    assert_equal exp_template.chomp, act_template

    # {"Bool": {"aws:SecureTransport": "true"}}
    template = <<-EOS
conds = [
  { '=': { 'aws:SecureTransport': true } }
]
Condition _iam_policy_conditions(conds)
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Condition": {
    "Bool": {
      "aws:SecureTransport": "true"
    }
  }
}
  EOS
    assert_equal exp_template.chomp, act_template

    # "BinaryEquals": { "key" : "QmluYXJ5VmFsdWVJbkJhc2U2NA==" }
    template = <<-EOS
conds = [
  { '=': { type: 'bin', 'key': 'QmluYXJ5VmFsdWVJbkJhc2U2NA==' } }
]
Condition _iam_policy_conditions(conds)
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Condition": {
    "BinaryEquals": {
      "key": "QmluYXJ5VmFsdWVJbkJhc2U2NA=="
    }
  }
}
  EOS
    assert_equal exp_template.chomp, act_template

    # {"IpAddress": {"aws:SourceIp": "203.0.113.0/24"}}
    template = <<-EOS
conds = [
  { '=': { type: 'ip', 'aws:SourceType': '203.0.113.0/24' } }
]
Condition _iam_policy_conditions(conds)
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Condition": {
    "IpAddress": {
      "aws:SourceType": "203.0.113.0/24"
    }
  }
}
  EOS
    assert_equal exp_template.chomp, act_template

    # {"ArnEquals": {"aws:SourceArn": "arn:aws:sns:REGION:123456789012:TOPIC-ID"}}
    template = <<-EOS
conds = [
  { '=': { type: 'arn', 'aws:SourceArn': 'arn:aws:sns:REGION:123456789012:TOPIC-ID' } }
]
Condition _iam_policy_conditions(conds)
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Condition": {
    "ArnEquals": {
      "aws:SourceArn": "arn:aws:sns:REGION:123456789012:TOPIC-ID"
    }
  }
}
  EOS
    assert_equal exp_template.chomp, act_template

    #  {"StringLikeIfExists": {"ec2:InstanceType": [
    #  "t1.*",
    #  "t2.*",
    #  "m3.*"
    # ]}}
    template = <<-EOS
conds = [
  { '=~': { exists: true, 'ec2:InstanceType': [ 't1.*', 't2.*', 'm3.*' ] } }
]
Condition _iam_policy_conditions(conds)
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Condition": {
    "StringLikeIfExists": {
      "ec2:InstanceType": [
        "t1.*",
        "t2.*",
        "m3.*"
      ]
    }
  }
}
  EOS
    assert_equal exp_template.chomp, act_template

    # {"Null":{"aws:TokenIssueTime":"true"}}
    template = <<-EOS
conds = [
  { '=': { type: 'nil', 'aws:TokenIssueTime': 'true' } }
]
Condition _iam_policy_conditions(conds)
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Condition": {
    "Null": {
      "aws:TokenIssueTime": "true"
    }
  }
}
  EOS
    assert_equal exp_template.chomp, act_template

    # "StringEquals": {
    #   "kms:EncryptionContext:aws:kinesis:arn":
    #     "arn:aws:kinesis:%REGION_NAME%:12345:stream/%FIREHOSE_STREAM_NAME%"
    # }
    template = <<-EOS
iam = _iam_arn('kinesis', [ { name: '%FIREHOSE_STREAM_NAME%' } ])
conds = [
  { '=': { 'kms:EncryptionContext:aws:kinesis:arn': iam } },
]
Condition _iam_policy_conditions(conds)
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Condition": {
    "StringEquals": {
      "kms:EncryptionContext:aws:kinesis:arn": {

      }
    }
  }
}
  EOS
    assert_equal exp_template.chomp, act_template
  end
end
