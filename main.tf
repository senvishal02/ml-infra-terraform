terraform {
  required_version = ">= 1.4.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# 🚀 1) Artifact / Model Bucket
module "ml_bucket" {
  source      = "./modules/s3"
  bucket_name = "ml-artifacts-${var.account_id}-${var.env}"

}

# 🏗️ 2) ECR Repository for Training Images
module "ml_ecr" {
  source          = "./modules/ecr"
  repository_name = "ml-training-repo-${var.env}"
}

# 🔐 3) IAM Roles (SageMaker, Pipeline, Build, etc.)
module "ml_iam" {
  source          = "./modules/iam"
  env             = var.env
  artifact_bucket = module.ml_bucket.bucket_name
}

# 🏗️ 4) CodeBuild for Docker Build + Training
module "ml_codebuild" {
  source             = "./modules/codebuild"
  region             = var.region
  account_id         = var.account_id
  env                = var.env
  github_owner       = var.github_owner
  github_repo        = var.github_repo # e.g. "user/ml-model-training"
  buildspec          = "buildspec.yml"
  ecr_repo_name      = module.ml_ecr.repo_name
  codebuild_role_arn = module.ml_iam.codebuild_role_arn
}




# 📦 5) CodePipeline to trigger when GitHub changes
module "ml_codepipeline" {
  source             = "./modules/codepipeline"
  env                = var.env
  artifact_bucket    = module.ml_bucket.bucket_name
  github_owner       = var.github_owner
  github_repo        = var.github_repo   # e.g. "user/ml-model-training"
  github_branch      = var.github_branch # e.g. "main"
  pipeline_role_arn  = module.ml_iam.codepipeline_role_arn
  build_project_name = module.ml_codebuild.project_name
}

# # 🧠 6) SageMaker Model + Endpoint
# module "sagemaker" {
#   source = "./modules/sagemaker"
#   env               = var.env
#   sagemaker_role_arn = var.sagemaker_role_arn

#   training_image           = var.training_image
#   training_s3_uri          = var.training_s3_uri
#   output_s3_uri            = var.output_s3_uri

#   training_instance_type    = var.training_instance_type
#   training_instance_count   = var.training_instance_count
#   volume_size_gb            = var.volume_size_gb
#   max_runtime_seconds       = var.max_runtime_seconds

#   inference_image          = var.inference_image
#   model_s3_path           = var.model_s3_path

#   instance_type           = var.instance_type
#   initial_instance_count  = var.initial_instance_count
# }

