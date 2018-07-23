require 'abstract_unit'

class DatapipelinePipelineTest < Minitest::Test
  def test_normal
    template = <<-EOS
parameter_objects = [ { test: { attributes: { test: "test" } } } ]
parameter_values = { test: "test" }
fields = { test: { ref: "test", string: "test" } }
pipeline_objects = [ test: { name: "test", fields: fields } ]
pipeline_tags = { test: "test" }
_datapipeline_pipeline "test", parameter_objects: parameter_objects, parameter_values: parameter_values,
                               objects: pipeline_objects, tags: pipeline_tags
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestPipeline": {
    "Type": "AWS::DataPipeline::Pipeline",
    "Properties": {
      "Activate": "true",
      "Description": "test pipeline description",
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
      "ParameterObjects": [
        {
          "Attributes": [
            {
              "Key": "test",
              "StringValue": "test"
            }
          ],
          "Id": "test"
        }
      ],
      "ParameterValues": [
        {
          "Id": "test",
          "StringValue": "test"
        }
      ],
      "PipelineObjects": [
        {
          "Fields": [
            {
              "Key": "test",
              "RefValue": "test",
              "StringValue": "test"
            }
          ],
          "Id": "test",
          "Name": "test"
        }
      ],
      "PipelineTags": [
        {
          "Key": "Name",
          "Value": {
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

  def test_aws
    template = <<-'EOS'
description = "Pipeline to backup DynamoDB data to S3"
parameter_objects = [
  { "myDDBReadThroughputRatio": { attributes: { description: "DynamoDB read throughput ratio",
                                                type: "Double",
                                                default: 0.2 } } },
  { "myOutputS3Loc": { attributes: { description: "S3 output bucket",
                                     type: "AWS::S3::ObjectKey",
                                     default: _{ Fn__Join [ "", [ "s3://", _{ Ref "S3OutputLoc" } ] ] } } } },
  { "myDDBTableName": { attributes: { description: "DynamoDB Table Name",
                                      type: "String" } } },
]
parameter_values = {
  myDDBTableName: _{ Ref "TableName" }
}
fields1 = { type: { string: "S3DataNode" }, dataFormat: { ref: "DDBExportFormat"}, directoryPath: { string: '#{myOutputS3Loc}/#{format(@scheduledStartTime, \'YYYY-MM-dd-HH-mm-ss\')}' } }
fields2 = { type: { string: "DynamoDBDataNode" } , tableName: { string: '#{myDDBTableName}' }, dataFormat: { ref: "DDBExportFormat" }, readThroughputPercent: { string: '#{myDDBReadThroughputRatio}' } }
fields3 = { type: { string: "DynamoDBExportDataFormat" } }
fields4 = { type: { string: "HiveCopyActivity" }, resizeClusterBeforeRunning: { string: true }, input: { ref: "DDBSourceTable" }, runsOn: { ref: "EmrClusterForBackup" }, output: { ref: "S3BackupLocation" } }
fields5 = { type: { string: "Schedule" }, occurrences: { string: 1 }, startAt: { string: "FIRST_ACTIVATION_DATE_TIME" }, period: { string: "1 Day" } }
fields6 = { type: { string: "Default" }, scheduleType: { string: "cron" }, failureAndRerunMode: { string: "CASCADE" }, role: { string: "DataPipelineDefaultRole" }, resourceRole: { string: "DataPipelineDefaultResourceRole" }, schedule: { ref: "DefaultSchedule" } }
fields7 = { type: { string: "EmrCluster" }, terminateAfter: { string: "2 Hours" }, amiVersion: { string: "3.3.2" }, masterInstanceType: { string: "m1.medium" }, coreInstanceType: { string: "m1.medium" }, coreInstanceCount: { string: 1 } }
objects = [
  { S3BackupLocation: { name: "Copy data to this S3 location", fields: fields1 } },
  { DDBSourceTable: { name: "DDBSourceTable", fields: fields2 } },
  { DDBExportFormat: { name: "DDBExportFormat", fields: fields3 } },
  { TableBackupActivity: { name: "TableBackupActivity", fields: fields4 } },
  { DefaultSchedule: { name: "RunOnce", fields: fields5 } },
  { Default: { name: "Default", fields: fields6 } },
  { EmrClusterForBackup: { name: "EmrClusterForBackup" ,fields: fields7 } },
]
tags = []
_datapipeline_pipeline "dynamo d b input s3 output hive",
                       { pipeline: "DynamoDBInputS3OutputHive",
                         description: description,
                         parameter_objects: parameter_objects, parameter_values: parameter_values,
                         objects: objects, tags: tags }
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-'EOS'
{
  "DynamoDBInputS3OutputHivePipeline": {
    "Type": "AWS::DataPipeline::Pipeline",
    "Properties": {
      "Activate": "true",
      "Description": "Pipeline to backup DynamoDB data to S3",
      "Name": "DynamoDBInputS3OutputHive",
      "ParameterObjects": [
        {
          "Attributes": [
            {
              "Key": "description",
              "StringValue": "DynamoDB read throughput ratio"
            },
            {
              "Key": "type",
              "StringValue": "Double"
            },
            {
              "Key": "default",
              "StringValue": "0.2"
            }
          ],
          "Id": "myDDBReadThroughputRatio"
        },
        {
          "Attributes": [
            {
              "Key": "description",
              "StringValue": "S3 output bucket"
            },
            {
              "Key": "type",
              "StringValue": "AWS::S3::ObjectKey"
            },
            {
              "Key": "default",
              "StringValue": {
                "Fn::Join": [
                  "",
                  [
                    "s3://",
                    {
                      "Ref": "S3OutputLoc"
                    }
                  ]
                ]
              }
            }
          ],
          "Id": "myOutputS3Loc"
        },
        {
          "Attributes": [
            {
              "Key": "description",
              "StringValue": "DynamoDB Table Name"
            },
            {
              "Key": "type",
              "StringValue": "String"
            }
          ],
          "Id": "myDDBTableName"
        }
      ],
      "ParameterValues": [
        {
          "Id": "myDDBTableName",
          "StringValue": {
            "Ref": "TableName"
          }
        }
      ],
      "PipelineObjects": [
        {
          "Fields": [
            {
              "Key": "type",
              "StringValue": "S3DataNode"
            },
            {
              "Key": "dataFormat",
              "RefValue": "DDBExportFormat"
            },
            {
              "Key": "directoryPath",
              "StringValue": "#{myOutputS3Loc}/#{format(@scheduledStartTime, 'YYYY-MM-dd-HH-mm-ss')}"
            }
          ],
          "Id": "S3BackupLocation",
          "Name": "Copy data to this S3 location"
        },
        {
          "Fields": [
            {
              "Key": "type",
              "StringValue": "DynamoDBDataNode"
            },
            {
              "Key": "tableName",
              "StringValue": "#{myDDBTableName}"
            },
            {
              "Key": "dataFormat",
              "RefValue": "DDBExportFormat"
            },
            {
              "Key": "readThroughputPercent",
              "StringValue": "#{myDDBReadThroughputRatio}"
            }
          ],
          "Id": "DDBSourceTable",
          "Name": "DDBSourceTable"
        },
        {
          "Fields": [
            {
              "Key": "type",
              "StringValue": "DynamoDBExportDataFormat"
            }
          ],
          "Id": "DDBExportFormat",
          "Name": "DDBExportFormat"
        },
        {
          "Fields": [
            {
              "Key": "type",
              "StringValue": "HiveCopyActivity"
            },
            {
              "Key": "resizeClusterBeforeRunning",
              "StringValue": "true"
            },
            {
              "Key": "input",
              "RefValue": "DDBSourceTable"
            },
            {
              "Key": "runsOn",
              "RefValue": "EmrClusterForBackup"
            },
            {
              "Key": "output",
              "RefValue": "S3BackupLocation"
            }
          ],
          "Id": "TableBackupActivity",
          "Name": "TableBackupActivity"
        },
        {
          "Fields": [
            {
              "Key": "type",
              "StringValue": "Schedule"
            },
            {
              "Key": "occurrences",
              "StringValue": "1"
            },
            {
              "Key": "startAt",
              "StringValue": "FIRST_ACTIVATION_DATE_TIME"
            },
            {
              "Key": "period",
              "StringValue": "1 Day"
            }
          ],
          "Id": "DefaultSchedule",
          "Name": "RunOnce"
        },
        {
          "Fields": [
            {
              "Key": "type",
              "StringValue": "Default"
            },
            {
              "Key": "scheduleType",
              "StringValue": "cron"
            },
            {
              "Key": "failureAndRerunMode",
              "StringValue": "CASCADE"
            },
            {
              "Key": "role",
              "StringValue": "DataPipelineDefaultRole"
            },
            {
              "Key": "resourceRole",
              "StringValue": "DataPipelineDefaultResourceRole"
            },
            {
              "Key": "schedule",
              "RefValue": "DefaultSchedule"
            }
          ],
          "Id": "Default",
          "Name": "Default"
        },
        {
          "Fields": [
            {
              "Key": "type",
              "StringValue": "EmrCluster"
            },
            {
              "Key": "terminateAfter",
              "StringValue": "2 Hours"
            },
            {
              "Key": "amiVersion",
              "StringValue": "3.3.2"
            },
            {
              "Key": "masterInstanceType",
              "StringValue": "m1.medium"
            },
            {
              "Key": "coreInstanceType",
              "StringValue": "m1.medium"
            },
            {
              "Key": "coreInstanceCount",
              "StringValue": "1"
            }
          ],
          "Id": "EmrClusterForBackup",
          "Name": "EmrClusterForBackup"
        }
      ],
      "PipelineTags": [
        {
          "Key": "Name",
          "Value": "DynamoDBInputS3OutputHive"
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
