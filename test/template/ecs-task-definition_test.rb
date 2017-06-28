require 'abstract_unit'

class EcsTaskDefinitionTest < Minitest::Test
  def test_normal
    template = <<-EOS
_ecs_task_definition "test", container_definitions: [ { name: "test", image: "test" } ], volumes: [ { name: "test" } ]
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestEcsTaskDefinition": {
    "Type": "AWS::ECS::TaskDefinition",
    "Properties": {
      "Volumes": [
        {
          "Name": "test"
        }
      ],
      "ContainerDefinitions": [
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
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end

  def test_aws
    template = <<-EOS
container1 = {
  ref_name: "app",
  entry_point: [ "/usr/sbin/apache2", "-D", "FOREGROUND" ],
  image: "amazon/amazon-ecs-sample",
  memory: 500,
  mount_points: [ { source_volume: "my-vol", container_path: "/var/www/my-vol" } ],
  port_mappings: [ { ref_container_port: "app", ref_host_port: "app" } ],
}
container2 = {
  name: "busybox",
  command: [ "/bin/sh -c \\"while true; do /bin/date > /var/www/my-vol/date; sleep 1; done\\"" ],
  cpu: 10,
  entry_point: [ "sh", "-c" ],
  essential: false,
  image: "busybox",
  memory: 500,
  port_mappings: nil,
  volumes_from: [
    { ref_source: "app" }
  ],
}
volumes = [
    { name: "my-vol", host: { source_path: "/var/lib/docker/vfs/dir/" } },
]
_ecs_task_definition "test", container_definitions: [ container1, container2 ], volumes: volumes
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestEcsTaskDefinition": {
    "Type": "AWS::ECS::TaskDefinition",
    "Properties": {
      "Volumes": [
        {
          "Name": "my-vol",
          "Host": {
            "SourcePath": "/var/lib/docker/vfs/dir/"
          }
        }
      ],
      "ContainerDefinitions": [
        {
          "Cpu": "10",
          "EntryPoint": [
            "/usr/sbin/apache2",
            "-D",
            "FOREGROUND"
          ],
          "Essential": "true",
          "Image": "amazon/amazon-ecs-sample",
          "Memory": "500",
          "MountPoints": [
            {
              "ContainerPath": "/var/www/my-vol",
              "SourceVolume": "my-vol",
              "ReadOnly": "false"
            }
          ],
          "Name": {
            "Ref": "App"
          },
          "PortMappings": [
            {
              "ContainerPort": {
                "Ref": "AppContainerPort"
              },
              "HostPort": {
                "Ref": "AppHostPort"
              }
            }
          ]
        },
        {
          "Command": [
            "/bin/sh -c \\"while true; do /bin/date > /var/www/my-vol/date; sleep 1; done\\""
          ],
          "Cpu": "10",
          "EntryPoint": [
            "sh",
            "-c"
          ],
          "Essential": "false",
          "Image": "busybox",
          "Memory": "500",
          "Name": "busybox",
          "VolumesFrom": [
            {
              "SourceContainer": {
                "Ref": "App"
              },
              "ReadOnly": "false"
            }
          ]
        }
      ]
    }
  }
}
    EOS
    assert_equal exp_template.chomp, act_template
  end
end
