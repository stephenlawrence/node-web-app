# node-web-app

This repository contains the scripts to build a node-web-app from scratch via AWS CodeBuild/CodePipeline and then deploy to Elastic Beanstalk as a Docker container.

## Prerequisites

Create an IAM group with  IAMFullAccess, AWSElasticBeanstalkFullAccess, CloudWatchLogsFullAccess, AmazonSSMFullAccess, AWSCodePipelineFullAccess, AWSCodeBuildAdminAccess, AWSCloudFormationReadOnlyAccess
Create an IAM user and assign to group to use with your ~/.aws/credentials

## Standing It Up

### Elastic Beanstalk
`cd terraform/us-east-1-dev/elasticbeanstalk`

`terraform init`

`terraform plan`

`terraform apply`

### CodeBuild and CodePipeline

`cd terraform/us-east-1-dev/cicd`

`terraform init`

`terraform plan`

`terraform apply`

## Updates

Make any needed changes to the files and run `terraform plan` then `terraform apply`
## Removal

`cd` into each folders and run `terraform destroy`

## TODO Add Terragrunt support

## Notes

This sample node web app had a few basic requirements:

* The code needed to be located at GitHub
* It had to be written as Infrasctructure as Code (IaC)
* It had to automatically deploy
* It had to run as a container
* It had to be deployed to AWS or Azure
* It had to auto-scale

With these points in mind I started thinking about various options including:

* AWS EKS (Too expensive, too much overhead)
* AWS ECS (Initial tests were not successful)
* Azure AKS (too much overhead)
* Azure acs-engine (Too expensive, too much overhead)
* AWS Elastic Beanstalk


After bouncing around on a few of the options I was able to build a prototype via the web-based AWS Console to create an Elastic Beanstalk application and successfully built and 
deployed the app via AWS CodeBuild and CodePipeline. I had no previous experience with any of the three so I figured it would be a good challenge.

Since no CI/CD tool requirement was stated I decided to go with the AWS CodePipeline tool since it had a fairly robust API and would eliminate the need for a service dependency 
such as Jenkins.

Once the prototype was done I exported all the json for the three services as a reference point and started work on re-creating this web-created stack via the `aws` and `eb` command 
line utilities.  I initially was thinking of using Terraform, but then thought maybe it was overkill for such a small project. I had started crafting bash
script and verified my initial hunch was right: I need to use something to manage all of the inter-dependencies between all the individual resources in 
in AWS. The eb creation was pretty straight forward but in order to build the the pipeline it was beginning to require a lot of crafty shell scripting work. It still was 
not working as smoothly as I had hoped

Knowing the general process, after numerous experiments, I decided to look for existing solutions for automating Beanstalk, CodeBuild, and CodePipeline.

There were sparse documents describing each system individually, and even fewer describing the specific environment I needed to create. I found a group called CloudPosse on 
github and they had some Terraform modules that looked promising. I began initially with a separate CloudBuild module and got that working completely. Tying it into 
CloudPipeline was going to be a hassle though so I looked deeper and found a cicd module they wrote that handled CodeBuild + CodePipeline but it was written for AWS ECR and 
not for Docker Hub where I was hosting the app image.

Along the way I made many customizations to their original modules and contributed a couple of PR's as well. I also spent some time refactoring the Terraform modules to be cleaner
and more easily adjusted in the future.

### Architecture

Here is the basic flow:

1) CodePipeline Polls GitHub for changes
1) CodePipeline triggers CodeBuild 
1) CodeBuild builds the Docker image and pushes to Docker Hub
1) CodePipeline triggers the re-deployment of the Docker image to Elastic Beanstalk

