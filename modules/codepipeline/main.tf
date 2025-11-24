resource "aws_codepipeline" "pipeline" {
  name     = "${var.env}-ml-pipeline"
  role_arn = var.pipeline_role_arn

  artifact_store {
    type     = "S3"
    location = var.artifact_bucket
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]
      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.github_connection.arn
        FullRepositoryId = "${var.github_owner}/${var.github_repo}"
        BranchName       = var.github_branch
      }
    }
  }

  stage {
    name = "Build"
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1" # Dynamic version
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      configuration = {
        ProjectName = var.build_project_name
      }
    }
  }

  #   stage {
  #     name = "Deploy"
  #     action {
  #       name             = "DeployModel"
  #       category         = "Deploy"
  #       owner            = "AWS"
  #       provider         = "Lambda"
  #       version          = var.action_version         # Dynamic version
  #       input_artifacts  = ["build_output"]
  #       configuration = {
  #         FunctionName = var.deploy_lambda_function   # Lambda to update endpoint or infra
  #       }
  #     }
  #   }
}

resource "aws_codestarconnections_connection" "github_connection" {
  name          = "github-connection-${var.env}"
  provider_type = "GitHub"
  tags = {
    Environment = var.env
  }
}