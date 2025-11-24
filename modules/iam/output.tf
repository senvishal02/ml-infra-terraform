# CodeBuild Role ARN
output "codebuild_role_arn" {
  description = "The ARN of the CodeBuild IAM role"
  value       = aws_iam_role.codebuild_role.arn
}

# CodePipeline Role ARN
output "codepipeline_role_arn" {
  description = "The ARN of the CodePipeline IAM role"
  value       = aws_iam_role.codepipeline_role.arn
}

# SageMaker Role ARN
output "sagemaker_role_arn" {
  description = "The ARN of the SageMaker IAM role"
  value       = aws_iam_role.sagemaker.arn
}
