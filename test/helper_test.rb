require 'abstract_unit'
require 'kumogata/template/helper'

class HelperTest < Minitest::Test
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

  def test_pair_value
    template = <<-EOS
Test _pair_value({ test: { "test key": "test value" } }, "test")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": [
    {
      "Key": "test key",
      "Value": "test value"
    }
  ]
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
Test _pair_value({ test: { "test key": "test value" } }, "test1")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": [

  ]
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_name
    template = <<-EOS
Test _name("test", { name: "test name" })
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
        "test-name"
      ]
    ]
  }
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
Test _name("test", { name: "test name", ref_name: "test name ref" })
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
          "Ref": "TestNameRef"
        }
      ]
    ]
  }
}
    EOS
    assert_equal exp_template.chomp, act_template


    template = <<-EOS
Test _name("test", { name: "test name", test: "test test" })
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": "test-test"
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
Test _name("test", { name: "test name", ref_test: "test test ref" })
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Ref": "TestTestRef"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
Test _name("test", { name: "test name", import_test: "test test import" })
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Fn::ImportValue": {
      "Fn::Sub": "test-test-import"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_resource_name
    assert_equal _resource_name("test"), "Test"
    assert_equal _resource_name("test", "Resource"), "TestResource"
    assert_equal _resource_name("test-name", "Resource"), "TestnameResource"
    assert_equal _resource_name("test Name", "Resource"), "TestNameResource"
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

  def test_ref_key
    assert_equal _ref_key?("test", { test: "test" }), true
    assert_equal _ref_key?("test", { import_test: "test" }), true
    assert_equal _ref_key?("test", { ref_test: "test" }), true
    assert_equal _ref_key?("test1", { test2: "test" }), false
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

    template = <<-EOS
Test _ref_string("test", import_test: "test")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Fn::ImportValue": {
      "Fn::Sub": "test"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_ref_string_default
    template = <<-EOS
Test _ref_string_default("test", { test: "test" }, '', "default")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": "test"
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
Test _ref_string_default("test", { ref_test: "test" }, '', "default")
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
Test _ref_string_default("test", {}, '', "default")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": "default"
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

    template = <<-EOS
Test _ref_array("tests", import_tests: [ "test1", "test2" ])
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": [
    {
      "Fn::ImportValue": {
        "Fn::Sub": "test1"
      }
    },
    {
      "Fn::ImportValue": {
        "Fn::Sub": "test2"
      }
    }
  ]
}
    EOS
    assert_equal exp_template.chomp, act_template


    template = <<-EOS
Tests _ref_array("tests", { name: "tests", ref_tests: [ "test1", "test2" ] }, "", "test")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Tests": [
    {
      "Fn::GetAtt": [
        "Test1",
        "test"
      ]
    },
    {
      "Fn::GetAtt": [
        "Test2",
        "test"
      ]
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

  def test_and
    template = <<-EOS
Test _and([ "test" ])
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Fn::And": [
      "test"
    ]
  }
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
Test _and([ _equals("test1", "test2"), _condition("test3") ])
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Fn::And": [
      {
        "Fn::Equals": [
          "test1",
          "test2"
        ]
      },
      {
        "Condition": "test3"
      }
    ]
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_equals
    template = <<-EOS
Test _equals("test1", "test2")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Fn::Equals": [
      "test1",
      "test2"
    ]
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_if
    template = <<-EOS
Test _if("test", "test1", "test2")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Fn::If": [
      "test",
      "test1",
      "test2"
    ]
  }
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
Test _if("test", _ref("Test1"), _ref("Test2"))
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Fn::If": [
      "test",
      {
        "Ref": "Test1"
      },
      {
        "Ref": "Test2"
      }
    ]
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_not
    template = <<-EOS
Test _not([ "test" ])
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Fn::Not": [
      "test"
    ]
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_or
    template = <<-EOS
Test _or([ "test" ])
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Fn::Or": [
      "test"
    ]
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_condition
    template = <<-EOS
Test _condition("test")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Condition": "test"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_base64
    template = <<-EOS
Test _base64("test")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Fn::Base64": "test"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_base64_shell
    template = <<-EOS
Test _base64_shell("test shell")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Fn::Base64": "#!/bin/bash\\ntest shell"
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

  def test_split
    template = <<-EOS
Test _split("test")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Fn::Split": [
      ",",
      "test"
    ]
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_sub
    template = <<-EOS
Test _sub("test")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Fn::Sub": "test"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
Test _sub("test.${Test}", [ { "test": "test" } ])
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Fn::Sub": [
      "test.${Test}",
      {
        "Test": {
          "Ref": "Test"
        }
      }
    ]
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_ref
    template = <<-EOS
Test _ref("test")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Ref": "test"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_export_string
    assert_equal _export_string({ name: "test" }, "test"), ""
    assert_equal _export_string({ name: "test", export: true }, "test"), "test-test"
  end

  def test_export
    template = <<-EOS
Test _export( { name: "test", export: "export" })
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Name": {
      "Fn::Sub": "${AWS::StackName}-export"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
Test _export({})
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": ""
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_depends
    template = <<-EOS
Test _depends([ { test: "test" } ], { test: "test" })
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": [
    "TestTest"
  ]
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
Test _depends([ "test" ], { test: "test" })
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": [
    "Test"
  ]
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_join
    template = <<-EOS
Test _join({ test: "test" })
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Fn::Join": [
      ",",
      {
        "test": "test"
      }
    ]
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_import
    template = <<-EOS
Test _import("test")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Fn::ImportValue": {
      "Fn::Sub": "test"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template

    template = <<-EOS
Test _import("test test1", "ref test")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Fn::ImportValue": {
      "Fn::Sub": "test-test1-ref-test"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_region
    template = <<-EOS
Test _region()
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Ref": "AWS::Region"
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

  def test_tags_string
    template = <<-EOS
Test _tags_string({ name: "test" })
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "Name": {
      "Fn::Join": [
        "-",
        [
          {
            "Ref": "Service"
          },
          "test"
        ]
      ]
    },
    "Service": {
      "Ref": "Service"
    },
    "Version": {
      "Ref": "Version"
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_var
    template = <<-EOS
Test _var("test")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": "${test}"
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
    "Ref": "TestZoneName"
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

  def test_timestamp_utc_duration
    assert_equal _timestamp_utc_duration(1), "PT1M"
    assert_equal _timestamp_utc_duration(1, 2), "PT2H1M"
    assert_equal _timestamp_utc_duration(1, 2, 3), "PT2H1M3S"
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
