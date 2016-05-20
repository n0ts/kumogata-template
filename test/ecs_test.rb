require 'abstract_unit'
require 'kumogata/template/ecs'

class EcsTest < Minitest::Test
  def test_ecs_load_balancers
    template = <<-EOS
Test _ecs_load_balancers(load_balancers: [ { container_name: "test", container_port: 80, lb_name: "test" } ])
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": [
    {
      "ContainerName": "test",
      "ContainerPort": "80",
      "LoadBalancerName": "test"
    }
  ]
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_ecs_container_definitions
    template = <<-EOS
Test _ecs_container_definitions(container_definitions: [ { name: "test", image: "test" } ])
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": [
    {
      "Cpu": "10",
      "Essential": "true",
      "Image": "test",
      "Memory": "300",
      "Name": "test",
      "PortMappings": [
        {
          "ContainerPort": "80"
        }
      ]
    }
  ]
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_ecs_mount_points
    template = <<-EOS
Test _ecs_mount_points(mount_points: [ { container_path: "/", source_volume: "/" } ])
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": [
    {
      "ContainerPath": "/",
      "SourceVolume": "/",
      "ReadOnly": "false"
    }
  ]
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_ecs_port_mappings
    template = <<-EOS
Test _ecs_port_mappings(port_mappings: [ { container_port: 80 } ])
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": [
    {
      "ContainerPort": "80"
    }
  ]
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_ecs_volumes_from
    template = <<-EOS
Test _ecs_volumes_from(volumes_from: [ { source: "test" } ])
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": [
    {
      "SourceContainer": "test",
      "ReadOnly": "false"
    }
  ]
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_ecs_volumes
    template = <<-EOS
Test _ecs_volumes(volumes: [ { name: "test" } ])
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": [
    {
      "Name": "test"
    }
  ]
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_ecs_volumes_host
    template = <<-EOS
Test _ecs_volumes_host(source_path: "test")
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "Test": {
    "SourcePath": "test"
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
