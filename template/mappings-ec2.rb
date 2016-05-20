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
# https://aws.amazon.com/marketplace/pp/B00CIYTQTC/ref=srh_res_product_title?ie=UTF8&sr=0-3&qid=1460447105907
AWSRegionArch2AMIAmazonLinuxOfficial do
  # 2016.03
  image_id = {
    virginia: "08111162",
    oregon: "c229c0a2",
    california: "1b0f7d7b",
    frankfurt: "e2df388d",
    ireland: "31328842",
    singapore: "e90dc68a",
    sydney: "f2210191",
    tokyo: "f80e0596",
    seoul: "6598510b",
    saopaulo: "1e159872",
  }

  AWS_REGION.each do |key, region|
    _(region) do
      HVM64 "ami-#{image_id[key]}"
    end
  end
end

# CentOS 7 (x86_64) with Updates HVM
# https://aws.amazon.com/marketplace/ordering/ref=dtl_psb_continue?ie=UTF8&productId=b7ee8a69-ee97-4a49-9e68-afaee216db2e
AWSRegionArch2AMICentos7Official do
  # 1602, released 02/26/2016
  image_id = {
    virginia: "6d1c2007",
    oregon: "d2c924b2",
    california: "af4333cf",
    ireland: "7abd0209",
    frankfurt: "9bf712f4",
    singapore: "f068a193",
    tokyo: "eec1c380",
    sydney: "fedafc9d",
    seoul: "c74789a9",
    saopaulo: "26b93b4a",
  }

  AWS_REGION.each do |key, region|
    _(region) do
      HVM64 "ami-#{image_id[key]}"
    end
  end
end

# Ubuntu Server 16.04 LTS
# https://cloud-images.ubuntu.com/locator/ec2/
AWSRegionArch2AMIUbuntu16Official do
  # 16.04 LTS 20160420.3
  image_id = {
    virginia: "840910ee",
    oregon:	"fa82739a",
    california: "fa82739a",
    frankfurt: "f0eb089f",
    ireland: "3079f543",
    singapore: "a5416cc6",
    sydney: "a5416cc6",
    tokyo: "3c5f4152",
    seoul: "a5416cc6",
    saopaulo: "567cf23a",
  }

  AWS_REGION.each do |key, region|
    _(region) do
      HVM64 "ami-#{image_id[key]}"
    end
  end
end

