require 'abstract_unit'

class DynamodbTableTest < Minitest::Test
  def test_normal
    template = <<-EOS
attribute = [ "test" ]
key_schema_hash = [{ hash: "test" }]
key_schema_range = [{ range: "test" }]
provisioned = { read: 10, write: 10 }
projection = { non_key: %w( test ), type: "include" }

global = [{ index: "test",
           key_schema: key_schema_range,
           projection: projection,
           provisioned: provisioned }]
local = [{ index: "test",
          key_schema: key_schema_range,
          projection: projection }]

_dynamodb_table "test", table: "test",
                        attribute: attribute,
                        key_schema: key_schema_hash,
                        provisioned: provisioned,
                        global: global,
                        local: local
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestTable": {
    "Type": "AWS::DynamoDB::Table",
    "Properties": {
      "AttributeDefinitions": [
        {
          "AttributeName": "test",
          "AttributeType": "S"
        }
      ],
      "GlobalSecondaryIndexes": [
        {
          "IndexName": "test",
          "KeySchema": [
            {
              "AttributeName": "test",
              "KeyType": "RANGE"
            }
          ],
          "Projection": {
            "NonKeyAttributes": [
              "test"
            ],
            "ProjectionType": "INCLUDE"
          },
          "ProvisionedThroughput": {
            "ReadCapacityUnits": "10",
            "WriteCapacityUnits": "10"
          }
        }
      ],
      "KeySchema": [
        {
          "AttributeName": "test",
          "KeyType": "HASH"
        }
      ],
      "LocalSecondaryIndexes": [
        {
          "IndexName": "test",
          "KeySchema": [
            {
              "AttributeName": "test",
              "KeyType": "RANGE"
            }
          ],
          "Projection": {
            "NonKeyAttributes": [
              "test"
            ],
            "ProjectionType": "INCLUDE"
          }
        }
      ],
      "ProvisionedThroughput": {
        "ReadCapacityUnits": "10",
        "WriteCapacityUnits": "10"
      },
      "TableName": "test",
      "Tags": [
        {
          "Key": "Name",
          "Value": "test"
        },
        {
          "Key": "Service",
          "Value": {
            "Ref": "Service"
          }
        },
        {
          "Key": "Version",
          "Value": {
            "Ref": "Version"
          }
        }
      ]
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
