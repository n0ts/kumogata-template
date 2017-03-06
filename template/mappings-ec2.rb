#
# Mappings EC2
#
require 'kumogata/template/helper'

AWSInstanceType2Arch do
  EC2_INSTANCE_TYPES.each do |type|
    _(type) do
      Arch "HVM64"
    end
  end
end

# Amazon Linux AMI (HVM / 64-bit)
# https://aws.amazon.com/marketplace/pp/B00CIYTQTC/
AWSRegionArch2AMIAmazonLinuxOfficial do
  # 2016.09
  image_id = {
    virginia:   "0b33d91d",
    ohio:       "c55673a0",
    california: "165a0876",
    oregon:     "f173cc91",
    canada:     "ebed508f",
    ireland:    "70edb016",
    frankfurt:  "af0fc0c0",
    london:     "f1949e95",
    tokyo:      "56d4ad31",
    seoul:      "dac312b4",
    singapore:  "dc9339bf",
    sydney:     "1c47407f",
    mumbai:     "f9daac96",
    saopaulo:   "80086dec",
  }

  AWS_REGION.each do |key, region|
    _(region) do
      HVM64 "ami-#{image_id[key]}"
    end
  end
end

# CentOS 7 (x86_64) with Updates HVM
# https://wiki.centos.org/Cloud/AWS
# https://aws.amazon.com/marketplace/pp/B00O7WM7QW/
AWSRegionArch2AMICentos7Official do
  # 1602, released 02/26/2016
  image_id = {
    virginia:   "6d1c2007",
    ohio:       "6a2d760f",
    california: "af4333cf",
    oregon:     "d2c924b2",
    canada:     "af62d0cb",
    ireland:    "7abd0209",
    frankfurt:  "9bf712f4",
    london:     "bb373ddf",
    tokyo:      "eec1c380",
    seoul:      "c74789a9",
    singapore:  "f068a193",
    sydney:     "fedafc9d",
    mumbai:     "95cda6fa",
    saopaulo:   "26b93b4a",
  }

  AWS_REGION.each do |key, region|
    _(region) do
      HVM64 "ami-#{image_id[key]}"
    end
  end
end

# Ubuntu Server 16.04 LTS
# https://cloud-images.ubuntu.com/locator/ec2/
# https://aws.amazon.com/marketplace/pp/B01JBL2M0O
AWSRegionArch2AMIUbuntu16Official do
  # 16.04 LTS 20160907.1 hvm:ebs-ssd
  image_id = {
    virginia:   "3267bb24",
    ohio:       "e5be9b80",
    california: "456f3125",
    oregon:	"df25a6bf",
    canada:     "",  ## N/A
    ireland:    "cdfed1ab",
    frankfurt:  "f6dd0899",
    london:     "bcc5d0d8",
    tokyo:      "0c05506b",
    seoul:      "fc38e892",
    singapore:  "4a299829",
    sydney:     "d02d2eb3",
    mumbai:     "",  ## N/A
    saopaulo:   "4cacca20",
  }

  AWS_REGION.each do |key, region|
    _(region) do
      HVM64 "ami-#{image_id[key]}"
    end
  end
end
