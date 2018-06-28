# docker-dkron
Docker image for Dkron

More info http://dkron.io

## How to use this image

start a Dkron instance

    $ docker run --name some-dkron -d dkron/dkron agent -server

This image includes EXPOSE 8080 8946, so standard container linking will make it automatically available to the linked containers (as the following examples illustrate).

# AWS ECS support

When running under AWS ECS the `EC2_JOIN` env variable is exported and contains the `--join` options to automatically join other dkron instances.
EC2 instances hosting a dkron daemon should be marked by the `dkron` tag, setting its value to `member`.
The target tag can be customized via the `AWS_TAG` env variable (default: `dkron=member`).

## ECS runner

This image contains a script located at `/usr/local/bin/ecs-run` which will help you to run scripts through docker images deployed on AWS ECS.
You can use it to schedule ecs-powered task just setting `ecs-run` as a dkron job command.

### ecs-run usage

```
Required arguments:
    -d | --task-definition       Name of task definition to deploy
    -c | --cluster               Name of ECS cluster
    -n | --container-name        Name of Docker container

Optional arguments:
    -m | --command
    --aws-instance-profile  Use the IAM role associated with this instance
    -D | --desired-count    The number of instantiations of the task to place.
    -t | --retries          Default is 12 for two hours. Script monitors ECS Service for new task definition to be running.
    -e | --tag-env-var      Get image tag name from environment variable. If provided this will override value specified in image name argument.
    -v | --verbose          Verbose output
    -r | --region           AWS Region
    -p | --profile          AWS Profile to use

Examples:
  Simple deployment of a service (Using env vars for AWS settings):
    ecs-run -c production1 -d foo-taskdef -n foo-container -m "sleep,15"
```