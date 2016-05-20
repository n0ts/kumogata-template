require 'abstract_unit'
require 'kumogata/template/dynamodb'

class DynamodbTest < Minitest::Test
  def test_dynamodb_attribute
    template = <<-EOS
Test _dynamodb_attribute([ { integer: "test1" }, { binary: "test2" }, "test3" ])
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": [
    {
      "AttributeName": "test1",
      "AttributeType": "N"
    },
    {
      "AttributeName": "test2",
      "AttributeType": "B"
    },
    {
      "AttributeName": "test3",
      "AttributeType": "S"
    }
  ]
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_dynamodb_key_schema
    template = <<-EOS
Test _dynamodb_key_schema([ { hash: "test1"  }, { range: "test2" }, "test3" ])
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": [
    {
      "AttributeName": "test1",
      "KeyType": "HASH"
    },
    {
      "AttributeName": "test2",
      "KeyType": "RANGE"
    },
    {
      "AttributeName": "test3",
      "KeyType": "HASH"
    }
  ]
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_dynamodb_projection
    template = <<-EOS
Test _dynamodb_projection(non_key: [ "test1" ], type: "include")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "NonKeyAttributes": [
      "test1"
    ],
    "ProjectionType": "INCLUDE"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_dynamodb_provisioned
    template = <<-EOS
Test _dynamodb_provisioned(read: 100, write: 1000)
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "ReadCapacityUnits": "100",
    "WriteCapacityUnits": "1000"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_dynamodb_stream
    template = <<-EOS
Test _dynamodb_stream(stream: "test")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "StreamViewType": "test"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_dynamodb_global
    template = <<-EOS
Test _dynamodb_global(index: "test",
                      key_schema: [ { hash: "test1"  }, { range: "test2" }, "test3" ],
                      projection: { non_key: [ "test1" ], type: "include" },
                      provisioned: { read: 100, write: 1000 })
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "IndexName": "test",
    "KeySchema": [
      {
        "AttributeName": "test1",
        "KeyType": "HASH"
      },
      {
        "AttributeName": "test2",
        "KeyType": "RANGE"
      },
      {
        "AttributeName": "test3",
        "KeyType": "HASH"
      }
    ],
    "Projection": {
      "NonKeyAttributes": [
        "test1"
      ],
      "ProjectionType": "INCLUDE"
    },
    "ProvisionedThroughput": {
      "ReadCapacityUnits": "100",
      "WriteCapacityUnits": "1000"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_dynamodb_local
    template = <<-EOS
Test _dynamodb_local(index: "test",
                     key_schema: [ { hash: "test1"  }, { range: "test2" }, "test3" ],
                     projection: { non_key: [ "test1" ], type: "include" })
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "IndexName": "test",
    "KeySchema": [
      {
        "AttributeName": "test1",
        "KeyType": "HASH"
      },
      {
        "AttributeName": "test2",
        "KeyType": "RANGE"
      },
      {
        "AttributeName": "test3",
        "KeyType": "HASH"
      }
    ],
    "Projection": {
      "NonKeyAttributes": [
        "test1"
      ],
      "ProjectionType": "INCLUDE"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
