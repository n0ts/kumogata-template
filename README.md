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

```
$ bundle
```

Or install it yourself as:

```
$ gem install kumogata-template
```


## Usage

```
Usage: kumogate-template <command> [args] [options]

Commands:
  init           STACK_NAME                 Initialize template
  * Other command same as kumogata2 commands

Options:
  * Options is same as the kumogata2 options
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

Resources do
  # And more kumogata-template examples at examples/

  # Create a S3 Bucket
  #_s3_bucket "sample"
end

Outputs do
  # Output S3 Bucket Information
  #_output_s3 "sample"
end
```


## What is **THE** difference `kumogata-template` and `kumogata2`

- For example launch EC2 instance.

### kumogata2

```
Resources do
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
  ...
end
```


### kumogata-template

- More simply write cloudformation stack.

```
Resources do
  user_data =<<EOS
yum install -y httpd
service httpd start
EOS

  _ec2_instance "my",
                image_id: "ami-XXXXXXXX",
                ref_instance_type: "my",
                key_name: "your_key_name",
                user_data: user_data
  ...
end
```

- And more example see [test code](test/template/)


## Support AWS CloudFormation Relase

**January 17, 2017** [Relese notes](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/ReleaseHistory.html)
