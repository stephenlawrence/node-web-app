provider "aws" {
  region = "${var.region}"
}

data "aws_availability_zones" "available" {}

module "vpc" {
  source     = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=master"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  name       = "node-demo"
  cidr_block = "10.0.0.0/16"
}

module "subnets" {
  source              = "git::https://github.com/cloudposse/terraform-aws-dynamic-subnets.git?ref=master"
  availability_zones  = ["${slice(data.aws_availability_zones.available.names, 0, var.max_availability_zones)}"]
  namespace           = "${var.namespace}"
  stage               = "${var.stage}"
  name                = "${var.name}"
  region              = "${var.region}"
  vpc_id              = "${module.vpc.vpc_id}"
  igw_id              = "${module.vpc.igw_id}"
  cidr_block          = "${module.vpc.vpc_cidr_block}"
  nat_gateway_enabled = "true"
}

module "elastic_beanstalk_application" {
  source      = "git::https://github.com/cloudposse/terraform-aws-elastic-beanstalk-application.git?ref=master"
  namespace   = "${var.namespace}"
  stage       = "${var.stage}"
  name        = "${var.name}"
  description = "${var.description}"
}

module "elastic_beanstalk_environment" {
  source    = "git::https://github.com/cloudposse/terraform-aws-elastic-beanstalk-environment.git?ref=master"
  namespace = "${var.namespace}"
  stage     = "${var.stage}"
  name      = "${var.name}"
  app       = "${module.elastic_beanstalk_application.app_name}"

  instance_type           = "${var.instance_type}"
  autoscale_min           = "${var.autoscale_min}"
  autoscale_max           = "${var.autoscale_max}"
  updating_min_in_service = "${var.updating_min_in_service}"
  updating_max_batch      = "${var.updating_max_batch}"

  loadbalancer_type   = "application"
  vpc_id              = "${module.vpc.vpc_id}"
  public_subnets      = "${module.subnets.public_subnet_ids}"
  private_subnets     = "${module.subnets.private_subnet_ids}"
  security_groups     = ["${module.vpc.vpc_default_security_group_id}"]
  solution_stack_name = "${var.solution_stack_name}"
  keypair             = ""
  healthcheck_url     = "${var.healthcheck_url}"

  env_vars = "${
      map(
        "ENV1", "Test1",
        "ENV2", "Test2",
        "ENV3", "Test3"
      )
    }"
}