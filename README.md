# node-web-app

This repository contains the scripts to build a node-web-app from scratch via AWS CodeBuild/CodePipeline and then deploy to Elastic Beanstalk as a Docker container.

## Prerequisites

Create an IAM group with  IAMFullAccess, AWSElasticBeanstalkFullAccess, CloudWatchLogsFullAccess, AmazonSSMFullAccess, AWSCodePipelineFullAccess, AWSCodeBuildAdminAccess, AWSCloudFormationReadOnlyAccess
Create an IAM user and assign to group to use with your ~/.aws/credentials

## Installation

`cd terraform/us-east-1-dev/elasticbeanstalk`

`terraform init`

`terraform plan`

`terraform apply`

`cd terraform/us-east-1-dev/cicd`

`terraform init`

`terraform plan`

`terraform apply`

## Updates

Make any needed changes to the files and run `terraform plan` then `terraform apply`
## Removal

`cd` into each folders and run `terraform destroy`

### TODO Add Terragrunt support