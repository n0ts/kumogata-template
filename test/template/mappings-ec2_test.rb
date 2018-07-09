require 'abstract_unit'
require 'kumogata/template/const'

class MappingsEc2Test < Minitest::Test
  def test_normal
    images = generate_image_values
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
    act_template = convert_image_values(run_client_as_json(template))

    exp_template = <<-EOS
{
  "AWSInstanceType2Arch": {
#{archs.chomp}
  },
  "AWSRegionArch2AMIAmazonLinuxOfficial": {
#{images.chomp}
  },
  "AWSRegionArch2AMIAmazonLinux2Official": {
#{images.chomp}
  },
  "AWSRegionArch2AMICentos7Official": {
#{images.chomp}
  },
  "AWSRegionArch2AMIUbuntu16Official": {
#{images.chomp}
  },
  "AWSRegionArch2AMIEcsOfficial": {
#{images.chomp}
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  private
  def generate_image_values
    values = ''
    AWS_REGION.each_with_index do |region, i|
      key, value = region
      next if key =~ /local/
      values += <<-EOS
    "#{value}": {
      "HVM64": "ami-*"
    }#{i == (AWS_REGION.size - 1) ? '' : ','}
    EOS
    end
    values
  end

  def convert_image_values(values)
    result = {}
    JSON.parse(values).each do |k ,v|
      if k == "AWSInstanceType2Arch"
        result[k] = v
        next
      else
        result[k] = {}
      end
      v.each do |kk, vv|
        result[k][kk] = {}
        vv.each do |kkk, vvv|
          result[k][kk][kkk] = vvv.gsub(/^ami-(.*)/, 'ami-*')
        end
      end
    end
    JSON.pretty_generate(result)
  end
end
