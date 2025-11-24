output "artifact_bucket" {
  value = module.ml_bucket.bucket_name
}

output "ecr_repo_url" {
  value = module.ml_ecr.repo_url
}

# output "sagemaker_endpoint" {
#   value = module.ml_sagemaker.endpoint_name
# }
output "ecr_iam_codebuild_role_arn" {
  value = module.ml_iam.codebuild_role_arn
}
output "ecr_iam_codepipeline_role_arn" {
  value = module.ml_iam.codepipeline_role_arn
}
output "ecr_iam_sagemaker_role_arn" {
  value = module.ml_iam.sagemaker_role_arn
}