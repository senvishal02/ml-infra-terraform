variable "env" {}
variable "artifact_bucket" {}
variable "codestar_connection_arn" {}
variable "github_repo_id" {}
variable "branch" {}
variable "pipeline_role_arn" {}
variable "build_project_name" {}
variable "action_version" {
  type        = string
  description = "Version for CodePipeline actions"
  default     = "1"
}

# variable "deploy_lambda_function" {
#   type        = string
#   description = "Lambda function to deploy/update SageMaker endpoint"
# }
