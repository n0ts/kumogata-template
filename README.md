# kumogata-template

[![Gem Version](https://badge.fury.io/rb/kumogata-template.svg)](http://badge.fury.io/rb/kumogata-template)
[![Build Status](https://travis-ci.org/n0ts/kumogata-template.svg?branch=master)](https://travis-ci.org/n0ts/kumogata-template)

## About

- `kumogate-template` is a template sets for [kumogata2](https://github.com/winebarrel/kumogata2).

## Installation

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


## AWS CloudFormation

- [Relese notes](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/ReleaseHistory.html)
  - Almost support release date is `January 17, 2017`

- [Support Resource Types](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-template-resource-type-ref.html)
  - AWS::AutoScaling::*
  - AWS::CertificateManager::*
  - AWS::CloudFront::**
  - AWS::CloudTrail::*
  - AWS::CloudWatch::*
  - AWS::CodeBuild::*
  - AWS::CodeCommit::*
  - AWS::CodeDeploy::*
  - AWS::DataPipeline::*
  - AWS::DynamoDB::*
  - AWS::EC2::*
  - AWS::ECS::*
  - AWS::ElastiCache::*
  - AWS::ElasticBeanstalk::*
  - AWS::ElasticLoadBalancing::*
  - AWS::ElasticLoadBalancingV2::*
  - AWS::EMR::*
  - AWS::Events::*
  - AMS::KMS::*
  - AWS::IAM::*
  - AWS::Lambda::*
  - AWS::Logs::*
  - AWS::RDS::*
  - AWS::Redshift::*
  - AWS::S3::*
  - AWS::SNS::*
  - AWS::SQS::*
