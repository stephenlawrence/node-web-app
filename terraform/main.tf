terraform {
  backend "local" {
    path = ".terraform/terraform.tfstate"
  }
}

provider "archive" {}


# Configure AWS Credentials & Region
provider "aws" {
  profile = "${var.profile}"
  region  = "${var.region}"
}


resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

}

resource "aws_subnet" "main" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "10.0.1.0/24"

  tags {
    Name = "Main"
  }
}

# Beanstalk Application
resource "aws_elastic_beanstalk_application" "app" {
  name        = "${var.application_name}"
  description = "${var.application_description}"
}

resource "aws_elastic_beanstalk_configuration_template" "app_template" {
  name                = "node-demo-tf-template-config"
  application         = "${aws_elastic_beanstalk_application.app.name}"
  solution_stack_name = "64bit Amazon Linux 2018.03 v2.12.5 running Docker 18.06.1-ce"
}

# Beanstalk Environment
resource "aws_elastic_beanstalk_environment" "app_environment" {
  name                = "${var.application_name}-${var.application_environment}"
  application         = "${aws_elastic_beanstalk_application.app.name}"
  solution_stack_name = "64bit Amazon Linux 2018.03 v2.12.5 running Docker 18.06.1-ce"
  tier                = "WebServer"

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = "${aws_vpc.main.id}"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = "${aws_subnet.main.id}"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"

    # Todo: As Variable
    value = "t2.micro"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"

    # Todo: As Variable
    value = "2"
  }
}