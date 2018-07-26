require 'abstract_unit'

class EcsTaskDefinitionTest < Minitest::Test
  def test_normal
    template = <<-EOS
_ecs_task_definition "test", containers: [ { name: "test", image: "test", ports: [ { container: 80 } ] } ], volumes: [ "test": "/test" ]
    EOS
    act_template = run_client_as_json(template)
    exp_template = <<-EOS
{
  "TestEcsTaskDefinition": {
    "Type": "AWS::ECS::TaskDefinition",
    "Properties": {
      "Volumes": [
        {
          "Name": "test",
          "Host": {
            "SourcePath": "/test"
          }
        }
      ],
      "Family": {
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
      "NetworkMode": "bridge",
      "ContainerDefinitions": [
        {
          "Cpu": "1",
          "DisableNetworking": "false",
          "Essential": "true",
          "Hostname": {
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
          "Image": "test",
          "Memory": "300",
          "Name": "test",
          "PortMappings": [
            {
              "ContainerPort": "80",
              "Protocol": "tcp"
            }
          ],
          "Privileged": "false",
          "ReadonlyRootFilesystem": "false"
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
  mounts: [ { source: "my-vol", path: "/var/www/my-vol" } ],
  ports: [ { ref_container: "app", ref_host: "app" } ],
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
  volumes: [
    { ref_source: "app" }
  ],
}
volumes = [
    { "my-vol": "/var/lib/docker/vfs/dir/" },
]
_ecs_task_definition "test", containers: [ container1, container2 ], volumes: volumes
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
      "Family": {
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
      "NetworkMode": "bridge",
      "ContainerDefinitions": [
        {
          "Cpu": "1",
          "DisableNetworking": "false",
          "EntryPoint": [
            "/usr/sbin/apache2",
            "-D",
            "FOREGROUND"
          ],
          "Essential": "true",
          "Hostname": {
            "Fn::Join": [
              "-",
              [
                {
                  "Ref": "Service"
                },
                {
                  "Ref": "App"
                }
              ]
            ]
          },
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
              },
              "Protocol": "tcp"
            }
          ],
          "Privileged": "false",
          "ReadonlyRootFilesystem": "false"
        },
        {
          "Command": [
            "/bin/sh -c \\"while true; do /bin/date > /var/www/my-vol/date; sleep 1; done\\""
          ],
          "Cpu": "10",
          "DisableNetworking": "false",
          "EntryPoint": [
            "sh",
            "-c"
          ],
          "Essential": "false",
          "Hostname": {
            "Fn::Join": [
              "-",
              [
                {
                  "Ref": "Service"
                },
                "busybox"
              ]
            ]
          },
          "Image": "busybox",
          "Memory": "500",
          "Name": "busybox",
          "Privileged": "false",
          "ReadonlyRootFilesystem": "false",
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
