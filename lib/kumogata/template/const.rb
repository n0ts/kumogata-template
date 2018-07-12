#
# AWS Constants
#

DOMAIN = 'amazonaws.com'

# http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html#concepts-available-regions
AWS_REGION = {
  virginia:    "us-east-1",
  ohio:        "us-east-2",
  california:  "us-west-1",
  oregon:      "us-west-2",
  canada:      "ca-central-1",
  frankfurt:   "eu-central-1",
  ireland:     "eu-west-1",
  london:      "eu-west-2",
  paris:       "eu-west-3",
  tokyo:       "ap-northeast-1",
  seoul:       "ap-northeast-2",
  osaka_local: "ap-northeast-3",
  singapore:   "ap-southeast-1",
  sydney:      "ap-southeast-2",
  mumbai:      "ap-south-1",
  saopaulo:    "sa-east-1",
}

PORT = {
  ssh: 22,
  http: 80,
  https: 443,
  memcached: 11211,
  mysql: 3306,
  mariadb: 3306,
  aurora: 3306,
  postgres: 5432,
  redis: 6379,
  redshift: 5439,
}

DEFAULT_MAINTENANCE_TIME = {
  elasticache: Time.local(2016, 4, 1, 5, 15),
  rds:         Time.local(2016, 4, 1, 5, 30),
  redshift:    Time.local(2016, 4, 1, 5, 45),
}

DEFAULT_SNAPSHOT_NUM = 10
DEFAULT_SNAPSHOT_TIME = {
  elasticache: Time.local(2016, 4, 1, 6, 15),
  rds:         Time.local(2016, 4, 1, 6, 30),
}

EC2_DEFAULT_IMAGE = "amazon linux official"

# https://aws.amazon.com/ec2/instance-types/
EC2_INSTANCE_TYPES =
  [
   # Model     vCPU  CPU(Credits/hour)  Mem(GiB)   Storage
   # t2.nano     1     3                0.5       EBS-Only
   # t2.micro    1     6                  1       EBS-Only
   # t2.small    1    12                  2       EBS-Only
   # t2.medium   2    24                  4       EBS-Only
   # t2.large    2    36                  8       EBS-Only
   "t2.nano", "t2.micro", "t2.small", "t2.medium", "t2.large",

   # Model      vCPU   Mem(GiB)  Storage   Network   EBS(Mbps)
   # m4.large     2      8       EBS-only  Moderate     450
   # m4.xlarge    4     16       EBS-only  High         750
   # m4.2xlarge   8     32       EBS-only  High       1,000
   # m4.4xlarge  16     64       EBS-only  High       2,000
   # m4.10xlarge 40    160       EBS-only  10Gps      4,000
   # m4.16xlarge 64    256       EBS Only  20Gps     10,000
   "m4.large", "m4.xlarge", "m4.2xlarge", "m4.4xlarge", "m4.10xlarge", "m4.16xlarge",

   # Model      vCPU   Mem(GiB)  Storage   EBS(Mbps)
   # c4.large     2   3.75       EBS-Only    500
   # c4.xlarge    4    7.5       EBS-Only    750
   # c4.2xlarge   8     15       EBS-Only  1,000
   # c4.4xlarge  16     30       EBS-Only  2,000
   # c4.8xlarge  36     60       EBS-Only  4,000
   "c4.large", "c4.xlarge", "c4.2xlarge", "c4.4xlarge", "c4.8xlarge",

   # Model      vCPU   Mem(GiB)  Storage   EBS(Mbps)
   # c5.large      2      4      EBS-Only  Up to 2,250
   # c5.xlarge     4      8      EBS-Only  Up to 2,250
   # c5.2xlarge    8     16      EBS-Only  Up to 2,250
   # c5.4xlarge   16     32      EBS-Only  2,250
   # c5.9xlarge   36     72      EBS-Only  4,500
   # c5.18xlarge  72    144      EBS-Only  9,000
   'c5.large', 'c5.xlarge', 'c5.2xlarge', 'c5.4xlarge', 'c5.9xlarge', 'c5.18xlarge',

   # Model      vCPU   Mem(GiB)  SSD Storage(GB)
   # r3.large     2     15.25      1 x 32
   # r3.xlarge    4     30.5       1 x 80
   # r3.2xlarge   8     61         1 x 160
   # r3.4xlarge  16    122         1 x 320
   # r3.8xlarge  32    244         2 x 320
   "r3.large", "r3.xlarge", "r3.2xlarge", "r3.4xlarge", "r3.8xlarge",

   # Model      vCPU   Mem (GiB)  Networking Perf.  SSD Storage (GB)
   # r4.large      2    15.25     Up to 10 Gigabit   EBS-Only
   # r4.xlarge     4    30.5      Up to 10 Gigabit   EBS-Only
   # r4.2xlarge    8    61        Up to 10 Gigabit   EBS-Only
   # r4.4xlarge   16   122        Up to 10 Gigabit   EBS-Only
   # r4.8xlarge   32   244        10 Gigabit         EBS-Only
   # r4.16xlarge  64   488        25 Gigabit         EBS-Only
   'r4.large', 'r4.2xlarge', 'r4.4xlarge', 'r4.8xlarge', 'r4.16xlarge',

   # Model      vCPU   Mem(GiB) SSD Storage(GB)
   # i2.xlarge    4     30.5    1 x 800
   # i2.2xlarge   8     61      2 x 800
   # i2.4xlarge  16    122      4 x 800
   # i2.8xlarge  32    244      8 x 800
   "i2.xlarge", "i2.2xlarge", "i2.4xlarge", "i2.8xlarge",

   # Model       vCPU   Mem(GiB)   Storage(GB)     Network(Gbps)
   # x1.16xlarge   64     174.5    1 x 1,920 SSD    10
   # x1.32xlarge  128   1,952      2 x 1,902 SSD    10
   "x1.16xlarge", "x1.32xlarge",

   # Model        vCPU   Mem(GiB)   Storage(GB)     Network(Gbps)
   # x1e.32xlarge  128   3,904      2 x 1,920       14,000
   # x1e.16xlarge   64   1,952      1 x 1,920       7,000
   # x1e.8xlarge    32     976      1 x 960         3,500
   # x1e.4xlarge    16     488      1 x 480         1,750
   # x1e.2xlarge     8     244      1 x 240         1,000
   # x1e.xlarge      4     122      1 x 120          500
   'x1e.32xlarge', 'x1e.16xlarge', 'x1e.8xlarge', 'x1e.4xlarge', 'x1e.2xlarge', 'x1e.xlarge',
  ]
EC2_DEFAULT_INSTANCE_TYPE = "t2.micro"

ELASTICACHE_DEFAULT_ENGINE = "redis"
# aws --region <REGION> elasticache describe-cache-engine-versions \
#     | jq -r '.CacheEngineVersions[] | select(.Engine == "<ENGINE>") | .EngineVersion'
ELASTICACHE_DEFAULT_ENGINE_VERSION = {
  memcached: "1.4.5",
  redis: "2.8.6",
}
# https://aws.amazon.com/elasticache/pricing/
ELASTICACHE_NODE_TYPES =
  [
   # Cache Node Type   vCPU   Mem (GiB)   Network Performance
   # cache.t2.micro      1     0.555      Low to Moderate
   # cache.t2.small      1     1.55       Low to Moderate
   # cache.t2.medium     2     3.22       Low to Moderate
   "cache.t2.micro", "cache.t2.small", "cache.t2.medium",

   # Cache Node Type   vCPU   Mem (GiB)   Network Performance
   # cache.m3.medium     1     2.78       Moderate
   # cache.m3.large      2     6.05       Moderate
   # cache.m3.xlarge     4    13.3        High
   # cache.m3.2xlarge    8    27.9        High
   "cache.m3.medium", "cache.m3.large", "cache.m3.xlarge", "cache.m3.2xlarge",

   # cache.m4.large      2     6.42       Moderate
   # cache.m4.xlarge     4    14.28       High
   # cache.m4.2xlarge    8    29.70       High
   # cache.m4.4xlarge   16    60.78       High
   # cache.m4.10xlarge  40   154.64       10 Gigabit
   "cache.m4.large", "cache.m4.xlarge",
   "cache.m4.2xlarge", "cache.m4.4xlarge", "cache.m4.10xlarge",

   # cache.r3.large      2    13.5        Moderate
   # cache.r3.xlarge     4    28.4        Moderate
   # cache.r3.2xlarge    8    58.2        High
   # cache.r3.4xlarge   16   118          High
   # cache.r3.8xlarge   32   237          10 Gigabit
   "cache.r3.large", "cache.r3.xlarge",
   "cache.r3.2xlarge", "cache.r3.4xlarge", "cache.r3.8xlarge",
  ]
ELASTICACHE_DEFAULT_NODE_TYPE = "cache.t2.medium"

# https://aws.amazon.com/rds/pricing/
RDS_INSTANCE_CLASSES =
  [
   # Instance Class   vCPU   ECU   Memory (GB)   EBS Optimized   Network Performance
   # db.m4.large       2      6.5    8            450 Mbps         Moderate
   # db.m4.xlarge      4     13     16            750 Mbps         High
   # db.m4.2xlarge     8     25.5   32            1000 Mbps        High
   # db.m4.4xlarge    16     53.5   64            2000 Mbps        High
   # db.m4.10xlarge   40    124.5  160           4000 Mbps        10 GBps
   "db.m4.large", "db.m4.xlarge", "db.m4.2xlarge", "db.m4.4xlarge", "db.m4.10xlarge",

   # Instance Class   vCPU   ECU   Memory (GB)   EBS Optimized   Network Performance
   # db.r3.large       2      6.5   15             No              Moderate
   # db.r3.xlarge      4     13     30.5           500 Mbps        Moderate
   # db.r3.2xlarge     8     26     61            1000 Mbps        High
   # db.r3.4xlarge    16     52    122            2000 Mbps        High
   # db.r3.8xlarge    32    104    244             No              10 Gbps
   "db.r3.large", "db.r3.xlarge", "db.r3.2xlarge", "db.r3.4xlarge", "db.r3.8xlarge",

   # Instance Class   vCPU   ECU   Memory (GB)   EBS Optimized   Network Performance
   # db.t2.micro       1      1      1             No              Low
   # db.t2.small       1      1      2             No              Low
   # db.t2.medium      2      2      4             No              Moderate
   # db.t2.large       2      2      8             No              Moderate
   "db.t2.micro", "db.t2.small", "db.t2.medium", "db.t2.large",
  ]
RDS_DEFAULT_INSTANCE_CLASS = "db.t2.medium"

RDS_AURORA_INSTANCE_CLASSES =
  [
   "db.t2.small", "db.t2.medium", "db.t2.large",
   "db.r3.large", "db.r3.xlarge", "db.r3.2xlarge", "db.r3.4xlarge", "db.r3.8xlarge",
  ]
RDS_AURORA_DEFAULT_INSTANCE_CLASS = "db.t2.medium"

RDS_DEFAULT_ENGINE = "mysql"
RDS_DEFAULT_CLUSTER_ENGINE = 'aurora-mysql'
# aws --region <REGION> rds describe-db-engine-versions --query "DBEngineVersions[] | [?Engine == 'mysql'].EngineVersion"
RDS_DEFAULT_ENGINE_VERSION = {
  aurora: "5.6.10a",
  "aurora-mysql": "5.7.12",
  "aurora-postgresql": "9.6.3",
  mariadb: "10.1.26",
  mysql: "5.7.19",
  postgres: "9.6.6",
}

# https://aws.amazon.com/redshift/pricing/
REDSHIFT_NODE_TYPES =
  [
   # Dense Compute
   # Node Size   vCPU   ECU   RAM(GiB)   Slices Per Node  Storage Per Node   Node Range   Total Capacity
   # dc2.large     2     7     15.25            2          160 GB NVMe-SSD      1–32         5.12 TB
   # dc2.8xlarge  32    99    244              16          2.56 TB NVMe-SSD     2–128         326 TB
   "dc2.large", "dc2.8xlarge",

   # Dense Storage
   # Node Size   vCPU   ECU   RAM(GiB)   Slices Per Node  Storage Per Node   Node Range   Total Capacity
   # ds2.xlarge    4     13    31               2            2 TB HDD           1–32        64 TB
   # ds2.8xlarge  36    119   244              16           16 TB HDD           2–128        2 PB
   "ds2.xlarge", "ds2.8xlarge",
  ]
REDSHIFT_DEFAULT_NODE_TYPE = "dc2.large"

# https://aws.amazon.com/elasticmapreduce/pricing/
EMR_INSTANCE_TYPES =
  [
   "c4.large", "c4.xlarge", "c4.2xlarge", "c4.4xlarge", "c4.8xlarge",
   "m4.large", "m4.xlarge", "m4.2xlarge", "m4.4xlarge", "m4.10xlarge",
   "i2.xlarge", "i2.2xlarge", "i2.4xlarge", "i2.8xlarge",
  ]
EMR_DEFAULT_INSTANCE_TYPE = "c4.large"

# http://docs.aws.amazon.com/ElasticMapReduce/latest/ReleaseGuide/emr-whatsnew.html
EMR_DEFAULT_RELEASE = "emr-4.6.0"

ELB_ACCESS_LOG_ACCOUNT_ID = {
  "us-east-1": "127311923021",
  "us-east-2": "033677994240",
  "us-west-1": "027434742980",
  "us-west-2": "797873946194",
  "ca-central-1": "985666609251",
  "eu-central-1": "054676820928",
  "eu-west-1": "156460612806",
  "eu-west-2": "652711504416",
  "eu-west-3": "009996457667",
  "ap-northeast-1": "582318560864",
  "ap-northeast-2": "600734575887",
  "ap-northeast-3": "383597477331",
  "ap-southeast-1": "114774131450",
  "ap-southeast-2": "783225319266",
  "ap-south-1":	"718504428378",
  "sa-east-1": "507241528517",
}

# http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/concepts.platforms.html
ELASTIC_BEANTALK_LINUX = "64bit Amazon Linux 2017.03"
ELASTIC_BEANTALK_PLATFORM = {
  packer: "#{ELASTIC_BEANTALK_LINUX} v2.2.0 running Packer 1.0.0",
  docker: "#{ELASTIC_BEANTALK_LINUX} v2.6.0 running Docker 1.12.6",
  go: "#{ELASTIC_BEANTALK_LINUX} v2.4.0 running Go 1.7",
  java: "#{ELASTIC_BEANTALK_LINUX} v2.5.0 running Java 8",
  java_tomcat: "#{ELASTIC_BEANTALK_LINUX} v2.6.0 running Tomcat 8 Java 8",
  windows_server: "64bit Windows Server 2012 R2 v1.2.0 running IIS 8.5",
  node: "#{ELASTIC_BEANTALK_LINUX} v4.1.0 running Node.js",
  php: "#{ELASTIC_BEANTALK_LINUX} v2.4.0 running PHP 7.0",
  python: "#{ELASTIC_BEANTALK_LINUX} v2.4.0 running Python 3.4",
  ruby_puma: "#{ELASTIC_BEANTALK_LINUX} v2.4.0 running Ruby 2.3 (Puma)",
  ruby_passenger: "#{ELASTIC_BEANTALK_LINUX} v2.4.0 running Ruby 2.3 (Passenger Standalone)",
}

ELASTIC_BEANTALK_EC2_DEFAULT_ROLE = "aws-elasticbeanstalk-ec2-role"
