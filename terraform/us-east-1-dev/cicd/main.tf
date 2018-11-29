module "build" {
  source              = "../../modules/aws/cicd"
  namespace           = "${var.namespace}"
  name                = "${var.name}"
  stage               = "${var.stage}"

  # Enable the pipeline creation
  enabled             = "true"

  # Elastic Beanstalk
  app                 = "${var.app}"
  env                 = "${var.env}"

  # Application repository on GitHub
  github_oauth_token  = "${var.github_oauth_token}"
  repo_owner          = "${var.repo_owner}"
  repo_name           = "${var.repo_name}"
  branch              = "${var.branch}"
  poll_source_changes = "true"

  # http://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref.html
  # http://docs.aws.amazon.com/codebuild/latest/userguide/build-spec-ref.html
  build_image         = "${var.build_image}"
  build_compute_type  = "${var.build_compute_type}"
  source_type         = "GITHUB"

  # These attributes are optional, used as ENV variables when building Docker images and pushing them to ECR
  # For more info:
  # http://docs.aws.amazon.com/codebuild/latest/userguide/sample-docker.html
  # https://www.terraform.io/docs/providers/aws/r/codebuild_project.html
  privileged_mode     = "true"
  aws_region          = "${var.aws_region}"
  aws_account_id      = "xxxxxxxxxx"
  image_repo_name     = "${var.image_repo_name}"
  image_tag           = "${var.image_tag}"
  environment_variables = [{
    "name"  = "DOCKER_USERNAME"
    "value" = "${var.image_repo_username}"
    },
    {
      "name"  = "DOCKER_PASSWORD"
      "value" = "${var.image_repo_password}"
    }
  ]
}