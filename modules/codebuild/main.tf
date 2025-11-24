resource "aws_codebuild_project" "project" {
  name          = "${var.env}-ml-build"
  service_role  = var.codebuild_role_arn
  artifacts { type = "NO_ARTIFACTS" }

  environment {
    compute_type                = "BUILD_GENERAL1_MEDIUM"
    image                       = "aws/codebuild/standard:6.0" # include awscli and docker
    privileged_mode             = true
    type                        = "LINUX_CONTAINER"
    environment_variable {
      name  = "REPOSITORY_URI"
      value = var.ecr_repo
    }
  }

  source {
    type            = "GITHUB"
    location        = var.github_repo
    git_clone_depth = 1
    buildspec       = var.buildspec
  }
}
