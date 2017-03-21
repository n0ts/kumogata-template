# kumogata-template

[![Gem Version](https://badge.fury.io/rb/kumogata-tempalte.svg)](http://badge.fury.io/rb/kumogata-template)
[![Build Status](https://travis-ci.org/n0ts/kumogata-template.svg?branch=master)](https://travis-ci.org/n0ts/kumogata-template)

## About

- `kumogate-template` is a template sets for [kumogata](https://github.com/winebarrel/kumogata).

## Installation

Add


Add this line to your application's Gemfile:

```ruby
gem 'kumogata-template'
```

And then execute:

  $ bundle

Or install it yourself as:

  $ gem install kumogata-template


## Usage

```
Usage: kumogate-template <command> [args] [options]

Commands:
  init           STACK_NAME                 Initialize template
  * Other command same as kumogata's commands

Options:
  * Options is same as the kumogata's options
```

- Initialize a sample template

```
$ bundle exec kumogata-template init sample
Saved template to sample.rb

$ cat sample.rb

AWSTemplateFormatVersion "2010-09-09"

Description (<<-EOS).undent
  Kumogata Template - sample stack
EOS

Parameters do
  _parameter "name", default: "sample",
                     description: "name of this stack"
  _parameter "service", default: "service",
                        description: "sample service"
  _parameter "version", default: "1.0.0",
                        description: "sample version"
end

Mappings do
end

Resources do
  _s3_bucket "sample"
end

Outputs do
  _output_s3 "sample"
end
```

  - Below sample template is create a s3 bucket.


## What is difference `kumogata-template` and `kumogata`

- For example launch EC2 instance.

### kumogata

```
  myEC2Instance do
    Type "AWS::EC2::Instance"
    Properties do
      ImageId "ami-XXXXXXXX"
      InstanceType { Ref "InstanceType" }
      KeyName "your_key_name"

      UserData do
        Fn__Base64 (<<-EOS).undent
          #!/bin/bash
          yum install -y httpd
          service httpd start
        EOS
      end
    end
  end
```


### kumogata-template

- More simply write cloudformation stack.

```
  user_data =<<EOS
yum install -y httpd
service httpd start
EOS

  _ec2_instance "my",
                image_id: "ami-XXXXXXXX",
                ref_instance_type: "my",
                key_name: "your_key_name",
                user_data: user_data
```

- more example see [test code](test/template)


## Support AWS Resource Types

- AWS::AutoScaling::AutoScalingGroup
- AWS::AutoScaling::LaunchConfiguration
- AWS::AutoScaling::LifecycleHook
- AWS::AutoScaling::ScalingPolicy
- AWS::AutoScaling::ScheduledAction
- AWS::CloudTrail::Trail
- AWS::CodeDeploy::Application
- AWS::CodeDeploy::DeploymentConfig
- AWS::CodeDeploy::DeploymentGroup
- AWS::DataPipeline::Pipeline
- AWS::DynamoDB::Table
- AWS::EC2::EIPAssociation
- AWS::EC2::EIP
- AWS::EC2::Instance
- AWS::EC2::InternetGateway
- AWS::EC2::NatGateway
- AWS::EC2::NetworkAclEntry
- AWS::EC2::NetworkAcl
- AWS::EC2::RouteTable
- AWS::EC2::Route
- AWS::EC2::SecurityGroup
- AWS::EC2::SubnetNetworkAclAssociation
- AWS::EC2::SubnetRouteTableAssociation
- AWS::EC2::Subnet
- AWS::EC2::VolumeAttachment
- AWS::EC2::VPCEndpoint
- AWS::EC2::VPCGatewayAttachment
- AWS::EC2::VPC
- AWS::ECS::Cluster
- AWS::ECS::Service
- AWS::ECS::TaskDefinition
- AWS::ElastiCache::CacheCluster
- AWS::ElastiCache::ParameterGroup
- AWS::ElastiCache::ReplicationGroup
- AWS::ElastiCache::SubnetGroup
- AWS::ElasticBeanstalk::ApplicationVersion
- AWS::ElasticBeanstalk::Application
- AWS::ElasticBeanstalk::ConfigurationTemplate
- AWS::ElasticBeanstalk::Environment
- AWS::ElasticLoadBalancing::LoadBalancer
- AWS::EMR::Cluster
- AWS::EMR::InstanceGroupConfig
- AWS::EMR::Step
- AWS::Events::Rule
- AWS::IAM::AccessKey
- AWS::IAM::Group
- AWS::IAM::InstanceProfile
- AWS::IAM::ManagedPolicy
- AWS::IAM::Policy
- AWS::IAM::Role
- AWS::IAM::UserToGroupAddition
- AWS::IAM::User
- AWS::Lambda::Alias
- AWS::Lambda::EventSourceMapping
- AWS::Lambda::Function
- AWS::Lambda::Permission
- AWS::Lambda::Version
- AWS::RDS::DBClusterParameterGroup
- AWS::RDS::DBCluster
- AWS::RDS::DBInstance
- AWS::RDS::DBParameterGroup
- AWS::RDS::DBSubnetGroup
- AWS::RDS::EventSubscription
- AWS::RDS::OptionGroup
- AWS::Redshift::ClusterParameterGroup
- AWS::Redshift::ClusterSubnetGroup
- AWS::Redshift::Cluster
- AWS::S3::BucketPolicy
- AWS::S3::Bucket
- AWS::SNS::Topic
- AWS::SQS::Queue


## TODO

- Support [Kumogata2](https://github.com/winebarrel/kumogata2)
- Useful kumogate-template snippets
