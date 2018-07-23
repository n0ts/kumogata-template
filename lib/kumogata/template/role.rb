#
# AWS IAM Roles
#

COGNITO_AUTH_ROLE =
  [
   { service: "mobileanalytics", action: "push events" },
   { services: %w( cognito-sync cognito-identity ) },
  ]

COGNITO_UNAUTH_ROLE =
  [
   { service: "mobileanalytics", action: "put events" },
   { service: "cognito-sync" },
  ]

API_GATEWAY_CLOUDWATCH_LOGS =
  [
   {
     service: "logs",
     actions: [
               "create log group", "create log stream",
               "describe log grops", "describe log streams",
               "get log evetns", "put log events", "filter log events",
              ],
     resource: "*",
   },
  ]

PINPOINT_ADMIN_ROLE =
  [
   { services: %w( mobiletargeting mobileanalytics ) },
   { service: "s3", action: "list all my buckets" },
   {
     service: "iam",
     actions: [
               "get policy",
               "get policy version",
               "list roles",
               "list attached role policies",
               "pass role",
              ],
   },
   {
     service: "kinesis",
     actions: [
               "describe stream",
               "list streams",
               "put records",
              ],
   },
   {
     service: "firehose",
     actions: [
               "describe delivery stream",
               "list delivery streams",
               "put record batch",
              ],
   },
  ]

ECS_INSTANCE_ROLE =
  [
   {
     service: "ecs",
     actions: [
               "create cluster", "deregister container instance",
               "discover poll endpoint", "poll",
               "register container instance",
               "start telemetry session",
               "update container instances state",
               "submit*",
              ]
   },
   {
     service: "ecr",
     actions: [
               "get authorization token",
               "batch check layer availability",
               "get download url for layer",
               "batch get image",
              ],

   },
   {
     service: "logs",
     actions: [
               "create log group",
               "create log stream",
               "describe log groups",
               "describe log streams",
               "put log events",
              ],
     resource: "*",
   },
  ]

ECS_SERVICE_ROLE =
  [
   {
     service: "ec2",
     actions: [
               "authorize security group ingress",
               "describe*",
              ],
   },
   {
     service: "elasticloadbalancing",
     actions: [
               "deregister instances from load balancer",
               "deregister targets",
               "describe*",
               "register instances with load balancer",
               "register targets",
              ],
   },
  ]

SSM_INSTANCE_ROLE =
  [
   {
     service: "ssm",
     actions: [
               "describe instance information",
               "describe association",
               "list associations",
               "get document",
               "get parameters",
               "list instance associations",
               "update association status",
               "update instance information",
              ],
   },
   {
     service: "ec2messages",
     actions: [
               "acknowledge message",
               "delete message",
               "fail message",
               "get endpoint",
               "get messages",
               "send reply",
              ],
   },
   {
     service: "ds",
     actions: [
               "create computer",
               "describe directories",
              ],
   },
   {
     service: "ec2",
     actions: [
               "describe instance status",
              ],
   },
  ]

KINESIS_FIREHOSE_DELIVERY_STREAM_ROLE =
  [
   {
     service: 's3',
     actions: [
               'abort multipart upload',
               'get bucket location',
               'get object',
               'list object',
               'list object multipart uploads',
               'put object',
              ],
     resources: [
                 '%BUCKET_NAME%',
                 '%BUCKET_NAME%/*',
                ]
   },
   {
     service: 'kinesis',
     actions: [
               'describe stream',
               'get shard iterator',
               'get records',
              ],
     resources: [
                 { name: '%STREAM_NAME%' },
               ],
   },
   {
     service: 'kms',
     actions: [
               'decrypt',
               'generate data key',
              ],
     resources: [
                 {
                   type: 'key',
                   id: '%KEY%',
                 },
                ],
     condition: [
                 {
                   '=': {
                     'kms:ViaService': "s3.%REGION%.#{DOMAIN}",
                   },
                   '=~': {
                     'kms:EncryptionContext:aws:s3:arn': 'arn:aws:s3:::%BUCKET_NAME%/%BUCKET_PREFIX%*',
                   }
                 },
                ],
   },
   {
     service: 'logs',
     actions: [
               'put log events',
              ],
     resources: [
                 {
                   type: 'log-group',
                   name: '%LOG_GROUP_NAME%',
                   stream: '%LOG_STREAM_NAME%',
                 },
                ],
   },
   {
     service: 'lambda',
     actions: [
               'invoke function',
               'get function configuration',
              ],
     resources: [
                 {
                   name: '%LAMBDA_FUNCTION_NAME%',
                   'alias': '%LAMBDA_FUNCTION_ALIAS%'
                 },
                ],
   },
  ]

PINPOINT_KINESIS_STREAM_ROLE =
  [
   {
     service: 'kinesis',
     actions: [
               'put records',
               'describe stream',
              ],
     resources: [
                 {
                   name: '%KINESIS_STREAM_NAME%',
                 },
                ],
   },
  ]

PINPOINT_KINESIS_FIREHOSE_DELIVERY_STREAM_ROLE =
  [
   {
     service: 'firehose',
     actions: [
               'describe delivery stream',
               'put record batch',
              ],
     resources: [
                 {
                   name: '%FIREHOSE_DELIVERY_STREAM_NAME%',
                 },
     ],
   },
  ]

# Datadog
# https://docs.datadoghq.com/integrations/aws/#installation
DATADOG_ROLE =
  [
   {
     service: "autoscaling",
     action: "describe*",
   },
   {
     service: "budgets",
     action: "view budget",
   },
   {
     service: "cloudtrail",
     actions: [
               "describe trails",
               "get trail status",
              ],
   },
   {
     service: "cloudwatch",
     actions: [
               "describe*",
               "get*",
               "list*",
              ],
   },
   {
     service: "codedeploy",
     actions: [
               "list*",
               "batch get*",
              ],
   },
   {
     service: "dynamodb",
     actions: [
               "list*",
               "describe*",
               ],
   },
   {
     service: "ec2",
     actions: [
               "describe*",
               "get*",
              ],
   },
   {
     service: "ecs",
     actions: [
               "describe*",
               "list*",
              ],
   },
   {
     service: "elasticache",
     actions: [
               "describe*",
               "list*",
              ],
   },
   {
     service: "elasticfilesystem",
     actions: [
               "describe file systems",
               "describe tags",
             ],
   },
   {
     service: "elasticloadbalancing",
     actoin: "describe*",
   },
   {
     service: "elasticmapreduce",
     actions: [
               "list*",
               "describe*",
               ],
   },
   {
     service: "es",
     actions: [
               "list tags",
               "list domain names",
               "describe elasticsearch domains",
              ],
   },
   {
     service: "kinesis",
     actions: [
               "list*",
               "describe*",
              ],
   },
   {
     service: "lambda",
     action: "list*",
   },
   {
     service: "logs",
     actions: [
               "get*",
               "describe*",
               "filter log events",
               "test metric filter",
              ],
     resource: "*",
   },
   {
     service: "rds",
     actions: [
               "describe*",
               "list*",
             ],
   },
   {
     service: "route53",
     action: "list*",
   },
   {
     service: "s3",
     actions: [
               "get bucket tagging",
               "list all my buckets",
              ],
   },
   {
     service: "ses",
     action: "get*",
   },
   {
     service: "sns",
     actions: [
               "list*",
               "publish",
              ],
   },
   {
     service: "sqs",
     action: "list queues",
   },
   {
     service: "support",
   },
   {
     service: "tag",
     actions: [
               "get resources",
               "get tag keys",
               "get tag values"
              ],
   }
  ]
DATADOG_ACCOUNT_ID = 464622532012
