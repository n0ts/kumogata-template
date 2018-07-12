#
# Mappings EC2
#
require 'kumogata/template/helper'

AWSInstanceType2Arch do
  EC2_INSTANCE_TYPES.each do |type|
    _(type) do
      Arch 'HVM64'
    end
  end
end

# Amazon Linux AMI x86_64 HVM GP2
# https://aws.amazon.com/marketplace/pp/B00CIYTQTC/
AWSRegionArch2AMIAmazonLinuxOfficial do
  # 2017.09.1.20180115, released 01/15/2018
  image_id = {
    virginia:   '97785bed',
    ohio:       'f63b1193',
    california: '824c4ee2',
    oregon:     'f2d3638a',
    canada:     'a954d1cd',
    frankfurt:  '5652ce39',
    ireland:    'd834aba1',
    london:     '403e2524',
    paris:      '8ee056f3',
    singapore:  '68097514',
    sydney:     '942dd1f6',
    seoul:      '863090e8',
    tokyo:      'ceafcba8',
    mumbai:     '531a4c3c',
    saopaulo:   '84175ae8',
  }

  AWS_REGION.each do |key, region|
    _(region) do
      HVM64 "ami-#{image_id[key]}"
    end if key !~ /local/
  end
end

# Amazon Linux 2 AMI x86_64 HVM GP2
# https://aws.amazon.com/amazon-linux-2/release-notes/
# for r in $(aws --profile <profile> --output text ec2 describe-regions --query 'Regions[].RegionName'); do i=$(aws --profile <profile> --region $r --output text ec2 describe-images --owners amazon --filters Name=name,Values="amzn2-ami-hvm*gp2" --query 'Images[].[Name, ImageId]'); echo "$r: \"$i\""; done
AWSRegionArch2AMIAmazonLinux2Official do
  # 2017.12.0.20180115
  image_id = {
    virginia:   '428aa838',
    ohio:       '710e2414',
    california: '4a787a2a',
    oregon:     '7f43f307',
    canada:     '7549cc11',
    frankfurt:  '1b2bb774',
    ireland:    'db1688a2',
    london:     '6d263d09',
    paris:      '5ce55321',
    singapore:  '4f89f533',
    sydney:     '38708c5a',
    seoul:      '3e04a450',
    tokyo:      'c2680fa4',
    mumbai:     '3b2f7954',
    saopaulo:   'f1337e9d',
  }

  AWS_REGION.each do |key, region|
    _(region) do
      HVM64 "ami-#{image_id[key]}"
    end if key !~ /local/
  end
end

# CentOS 7 x86_64 with Updates HVM
# https://wiki.centos.org/Cloud/AWS
# https://aws.amazon.com/marketplace/pp/B00O7WM7QW/
AWSRegionArch2AMICentos7Official do
  # 18001_01, released 01/14/2018
  image_id = {
    virginia:   '4bf3d731',
    ohio:       'e1496384',
    california: '65e0e305',
    oregon:     'a042f4d8',
    canada:     'dcad28b8',
    frankfurt:  '337be65c',
    ireland:    '6e28b517',
    london:     'ee6a718a',
    paris:      'bfff49c2',
    singapore:  'd2fa88ae',
    sydney:     'b6bb47d4',
    seoul:      '7248e81c',
    tokyo:      '25bd2743',
    mumbai:     '5d99ce32',
    saopaulo:   'f9adef95',
  }

  AWS_REGION.each do |key, region|
    _(region) do
      HVM64 "ami-#{image_id[key]}"
    end if key !~ /local/
  end
end

# Ubuntu 16.04 LTS - Xenial (HVM)
# https://cloud-images.ubuntu.com/locator/ec2/
# https://aws.amazon.com/marketplace/pp/B01JBL2M0O
AWSRegionArch2AMIUbuntu16Official do
  # 16.04 LTS 2018022, released 03/06/2018
  image_id = {
    virginia:   'b46295c9',
    ohio:       'f6cef993',
    california: 'c16862a1',
    oregon:	'1c1d9664',
    canada:     '919b1cf5',
    frankfurt:  '6283ef0d',
    ireland:    '70054309',
    london:     'be4aaed9',
    paris:      '5563d528',
    singapore:  '8f4f05f3',
    sydney:     'ed77b18f',
    seoul:      'e546eb8b',
    tokyo:      '64612102',
    mumbai:     '',  ## N/A
    saopaulo:   '4a733826',
  }

  AWS_REGION.each do |key, region|
    _(region) do
      HVM64 "ami-#{image_id[key]}"
    end if key !~ /local/ and !image_id[key].empty?
  end
end

# Amazon Linux AMI 2017.09.i x86_64 ECS HVM GP2
# http://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI_launch_latest.html
AWSRegionArch2AMIEcsOfficial do
  # 2017.09.j
  image_id = {
    ohio:       'ef64528a',
    virginia:   'cad827b7',
    oregon:	'baa236c2',
    california: '29b8b249',
    paris:      '0356e07e',
    london:     '25f51242',
    ireland:    '64c4871d',
    frankfurt:  '3b7d1354',
    seoul:      '3b19b455',
    tokyo:      'bb5f13dd',
    sydney:     'a677b6c4',
    singapore:  'f88ade84',
    canada:     'db48cfbf',
    mumbai:     '9e91cff1',
    saopaulo:   'da2c66b6',
  }

  AWS_REGION.each do |key, region|
    _(region) do
      HVM64 "ami-#{image_id[key]}" if region !~ /local/
    end if key !~ /local/ and !image_id[key].empty?
  end
end
