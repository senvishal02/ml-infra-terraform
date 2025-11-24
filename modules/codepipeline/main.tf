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
      version          = var.action_version         # Dynamic version
      output_artifacts = ["source_output"]
      configuration = {
        ConnectionArn    = var.codestar_connection_arn
        FullRepositoryId = var.github_repo_id
        BranchName       = var.branch
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
      version          = var.action_version         # Dynamic version
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
