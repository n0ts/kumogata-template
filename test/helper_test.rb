require 'abstract_unit'
require 'kumogata/template/helper'

class HelperTest < Minitest::Test
  def test_resource_name
    assert_equal _resource_name("test"), "Test"
    assert_equal _resource_name("test", "Resource"), "TestResource"
    assert_equal _resource_name("test-name", "Resource"), "TestnameResource"
    assert_equal _resource_name("test Name", "Resource"), "TestNameResource"
  end

  def test_array
    assert_equal _array("test"), [ "test" ]
    assert_equal _array([ "test" ]), [ "test" ]
    assert_equal _array({ test: "test" }), [ "test" ]
  end

  def test_bool
    assert_equal _bool("test", { test: true }), true
    assert_equal _bool("test", { test: false }), false
    assert_equal _bool("test", { test1: false }, true), true
    assert_equal _bool("test", { test1: false }, false), false
  end

  def test_integer
    assert_equal _integer("test", { test: 1 }), 1
    assert_equal _integer("test", { test: 2 }, 1), 2
    assert_equal _integer("test", { test1: 1 }), 0
    assert_equal _integer("test", { test1: 1 }, 2), 2
  end

  def test_capitalize
    assert_equal _capitalize("test test"), "TestTest"
  end

  def test_description
    description = _description <<-EOS
  test description,
  test
EOS
    assert_equal description, "test description, test"
  end

  def test_valid_values
    assert_equal _valid_values("test1", ["test1", "test2"]), "test1"
    assert_equal _valid_values("test3", ["test1", "test2"], "test1"), "test1"
    assert_equal _valid_values("test1", ["Test1", "Test2"], "Test1"), "Test1"
  end

  def test_valid_numbers
    assert_equal _valid_numbers(1, 0, 1, 2), 1
    assert_equal _valid_numbers(2, 1, 2, 4), 2
    assert_equal _valid_numbers(2, 0, 1, 2), 2
    assert_nil _valid_numbers(3, 0, 1)
    assert_nil _valid_numbers(nil, 0, 1)
  end

  def test_ref_string
    template = <<-EOS
Test _ref_string("test", {})
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": ""
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
Test _ref_string("test", test: "test")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": "test"
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_ref_array
    assert_equal _ref_array("tests", name: "array"), []

    template = <<-EOS
Tests _ref_array("tests", name: "tests", ref_tests: [ "test1", "test2" ])
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Tests": [
    {
      "Ref": "Test1"
    },
    {
      "Ref": "Test2"
    }
  ]
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
Tests _ref_array("tests", { name: "tests", ref_tests: [ "test1", "test2" ] }, "test" )
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Tests": [
    {
      "Ref": "Test1Test"
    },
    {
      "Ref": "Test2Test"
    }
  ]
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
Tests _ref_array("tests", name: "tests", ref_tests: "test1")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Tests": [
    {
      "Ref": "Test1"
    }
  ]
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_ref_attr_string
    template = <<-EOS
Test _ref_attr_string("test", "test1", test: "test")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": "test"
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
Test _ref_attr_string("test", "test1", ref_test: "test")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Fn::GetAtt": [
      "Test",
      "test1"
    ]
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_ref_name
    template = <<-EOS
Test _ref_name("test", test: "test")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": "test"
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
Test _ref_name("test", test: "test test")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": "test-test"
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
Test _ref_name("test", ref_test: "test")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Fn::Join": [
      "-",
      [
        {
          "Ref": "Service"
        },
        {
          "Ref": "Test"
        }
      ]
    ]
  }
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
Test _ref_name("test", raw_test: "test")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": "test"
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
Test _ref_name("test", ref_raw_test: "test")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Ref": "Test"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
Test _ref_name("test", {})
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Fn::Join": [
      "-",
      [
        {
          "Ref": "Service"
        },
        {
          "Ref": "Name"
        }
      ]
    ]
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_ref_name_default
    template = <<-EOS
Test _ref_name_default("test", { name: "test1" })
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": "test1"
}
    EOS
    assert_equal exp_template.chomp, act_template

    # _ref_name_default(name, args, ref_name = '')
  end

  def test_attr_string
    template = <<-EOS
Test _attr_string("test", "test1")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Fn::GetAtt": [
      "Test",
      "test1"
    ]
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_find_in_map
    template = <<-EOS
Test _find_in_map("Test", "test1", "test2")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Fn::FindInMap": [
      "Test",
      "test1",
      "test2"
    ]
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_select
    template = <<-EOS
Test _select(1, %w( test1 test2 ))
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Fn::Select": [
      "1",
      [
        "test1",
        "test2"
      ]
    ]
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_tag
    template = <<-EOS
Test _tag(key: "test", value: "test")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Key": "Test",
    "Value": "test"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
Test _tag({key: "ref_test", value: "test"})
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Key": "Test",
    "Value": {
      "Ref": "Test"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_tags
    template = <<-EOS
Test _tags(name: "test")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": [
    {
      "Key": "Name",
      "Value": {
        "Fn::Join": [
          "-",
          [
            {
              "Ref": "Service"
            },
            "test"
          ]
        ]
      }
    },
    {
      "Key": "Service",
      "Value": {
        "Ref": "Service"
      }
    },
    {
      "Key": "Version",
      "Value": {
        "Ref": "Version"
      }
    }
  ]
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
Test _tags({ name: "test", tags_append: { ref_test: "test" } })
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": [
    {
      "Key": "Name",
      "Value": {
        "Fn::Join": [
          "-",
          [
            {
              "Ref": "Service"
            },
            "test"
          ]
        ]
      }
    },
    {
      "Key": "Service",
      "Value": {
        "Ref": "Service"
      }
    },
    {
      "Key": "Version",
      "Value": {
        "Ref": "Version"
      }
    },
    {
      "Key": "Test",
      "Value": {
        "Ref": "Test"
      }
    }
  ]
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_tag_name
    template = <<-EOS
Test _tag_name(name: "test")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Fn::Join": [
      "-",
      [
        {
          "Ref": "Service"
        },
        "test"
      ]
    ]
  }
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
Test _tag_name(ref_name: "test")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Fn::Join": [
      "-",
      [
        {
          "Ref": "Service"
        },
        {
          "Ref": "Test"
        }
      ]
    ]
  }
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
Test _tag_name(tag_name: "test")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": "test"
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
Test _tag_name(ref_tag_name: "test")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Ref": "Test"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
Test _tag_name({ name: "test", ref_tag_name: "test" })
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Ref": "Test"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
Test _tag_name(ref_raw_tag_name: "test")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Ref": "Test"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
Test _tag_name(raw_tag_name: "test")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": "test"
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_availability_zone
    template = <<-EOS
Test _availability_zone(ref_subnet: "test")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Fn::GetAtt": [
      "TestSubnet",
      "AvailabilityZone"
    ]
  }
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
Test _availability_zone({ ref_subnet: "test", ref_az: "test" }, false)
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Ref": "Test"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
Test _availability_zone({})
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": ""
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_availability_zones
    template = <<-EOS
Test _availability_zones(ref_subnet: "test")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": [
    {
      "Fn::GetAtt": [
        "TestSubnet",
        "AvailabilityZone"
      ]
    }
  ]
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
Test _availability_zones(ref_subnets: [ "test" ])
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": [
    {
      "Fn::GetAtt": [
        "TestSubnet",
        "AvailabilityZone"
      ]
    }
  ]
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
Test _availability_zones({ ref_subnet: "test", ref_azs: [ "test" ] }, false)
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": [
    {
      "Ref": "TestZone"
    }
  ]
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
Test _availability_zones({ ref_subnet: "test", ref_az: "test" }, false)
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": [
    {
      "Ref": "TestZone"
    }
  ]
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
Test _availability_zones({})
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Fn::GetAZs": {
      "Ref": "AWS::Region"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_timestamp_utc
    assert_equal _timestamp_utc(Time.local(2016, 4, 1)), "2016-03-31T15:00:00Z"
    assert_equal _timestamp_utc(Time.local(2016, 4, 1), "cron"), "00 15 31 03 4"
  end

  def test_timestamp_utc_from_string
    assert_equal _timestamp_utc_from_string("2016-04-01 00:00"), "2016-03-31T15:00:00Z"
  end

  def test_maintenance_window
    start_time = Time.local(2016, 4, 1, 3, 30)
    end_time = start_time + (60 * 60)
    format = "%a:%H:%M"
    utc_start_time = start_time.utc.strftime(format)
    utc_end_time = end_time.utc.strftime(format)
    assert_equal "#{utc_start_time}-#{utc_end_time}", _maintenance_window("elasticache", start_time)
  end

  def test_window_time
    start_time = Time.local(2016, 4, 1, 3, 30)
    end_time = start_time + (60 * 60)
    format = "%H:%M"
    utc_start_time = start_time.utc.strftime(format)
    utc_end_time = end_time.utc.strftime(format)
    assert_equal "#{utc_start_time}-#{utc_end_time}", _window_time("elasticache", start_time)
  end
end
