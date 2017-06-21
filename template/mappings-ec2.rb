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
  # 2017.03.0.20170417, released 04/19/2017
  image_id = {
    virginia:   "c58c1dd3",
    ohio:       "4191b524",
    california: "7a85a01a",
    oregon:     "4836a428",
    canada:     "0bd66a6f",
    ireland:    "01ccc867",
    frankfurt:  "b968bad6",
    london:     "b6daced2",
    tokyo:      "923d12f5",
    seoul:      "9d15c7f3",
    singapore:  "fc5ae39f",
    sydney:     "162c2575",
    mumbai:     "52c7b43d",
    saopaulo:   "37cfad5b",
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
  # 1704, released 05/15/2017
  image_id = {
    virginia:   "46c1b650",
    ohio:       "18f8df7d",
    california: "f5d7f195",
    oregon:     "f4533694",
    canada:     "28823e4c",
    ireland:    "061b1560",
    frankfurt:  "fa2df395",
    london:     "e05a4d84",
    tokyo:      "29d1e34e",
    seoul:      "08e93466",
    singapore:  "7d2eab1e",
    sydney:     "34171d57",
    mumbai:     "3c0e7353",
    saopaulo:   "b31a75df",
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
  # 20170411, released 04/11/2017
  image_id = {
    virginia:   "e4139df2",
    ohio:       "33ab8f56",
    california: "30476250",
    oregon:	"17ba2a77",
    canada:     "9eee52fa",
    ireland:    "b5a893d3",
    frankfurt:  "1b4d9e74",
    london:     "4d3a2e29",
    tokyo:      "c9e3c0ae",
    seoul:      "3cda0852",
    singapore:  "6e74ca0d",
    sydney:     "92e8e6f1",
    mumbai:     "",  ## N/A
    saopaulo:   "36187a5a",
  }

  AWS_REGION.each do |key, region|
    _(region) do
      HVM64 "ami-#{image_id[key]}"
    end
  end
end
