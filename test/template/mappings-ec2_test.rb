require 'abstract_unit'
require 'kumogata/template/const'

class MappingsEc2Test < Minitest::Test
  def test_normal
    # from mappings-ec2
    amazon_image_id = {
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
    amazon_images = get_image_values(amazon_image_id)
    centos7_image_id = {
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
    centos7_images = get_image_values(centos7_image_id)
    ubuntu16_image_id = {
      virginia: "2ef48339",
      oregon:	"746aba14",
      california: "a9a8e4c9",
      frankfurt: "a9a557c6",
      ireland: "643d4217",
      singapore: "42934921",
      sydney: "623c0d01",
      tokyo: "919cd68",
      seoul: "", ## N/A
      saopaulo: "60bd2d0c",
    }
    ubuntu16_images = get_image_values(ubuntu16_image_id)

    archs = ""
    EC2_INSTANCE_TYPES.each_with_index do |type, i|
      archs += <<-EOS
    "#{type}": {
      "Arch": "HVM64"
    }#{i == (EC2_INSTANCE_TYPES.size - 1) ? '' : ','}
    EOS
    end

    template = <<-EOS
_mappings_ec2 "test"
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "AWSInstanceType2Arch": {
#{archs.chomp}
  },
  "AWSRegionArch2AMIAmazonLinuxOfficial": {
#{amazon_images.chomp}
  },
  "AWSRegionArch2AMICentos7Official": {
#{centos7_images.chomp}
  },
  "AWSRegionArch2AMIUbuntu16Official": {
#{ubuntu16_images.chomp}
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  private
  def get_image_values image_ids
    values = ''
    AWS_REGION.each_with_index do |v, i|
      region, location = v
      values += <<-EOS
    "#{location}": {
      "HVM64": "ami-#{image_ids[region]}"
    }#{i == (AWS_REGION.size - 1) ? '' : ','}
    EOS
    end
    values
  end
end
