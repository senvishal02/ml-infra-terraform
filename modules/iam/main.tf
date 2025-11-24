# CodeBuild Role
resource "aws_iam_role" "codebuild_role" {
  name = "codebuild-role-${var.env}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = "sts:AssumeRole",
      Principal = { Service = "codebuild.amazonaws.com" }
    }]
  })
}
# Attach policies (example managed)
resource "aws_iam_role_policy_attachment" "codebuild_attach1" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}
resource "aws_iam_role_policy_attachment" "codebuild_attach2" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}
resource "aws_iam_role_policy_attachment" "codebuild_attach3" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
}

# CodePipeline Role
resource "aws_iam_role" "codepipeline_role" {
  name = "codepipeline-role-${var.env}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = "sts:AssumeRole",
      Principal = { Service = "codepipeline.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "pipeline_admin" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# SageMaker Role
resource "aws_iam_role" "sagemaker" {
  name = "sagemaker-role-${var.env}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = "sts:AssumeRole",
      Principal = { Service = "sagemaker.amazonaws.com" }
    }]
  })
}

# Optional fine-grained policy
resource "aws_iam_role_policy" "sagemaker_inline" {
  name   = "sagemaker-inline-policy-${var.env}"
  role   = aws_iam_role.sagemaker.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["s3:GetObject", "s3:PutObject", "s3:ListBucket"],
        Resource = "*"
      },
      {
        Effect   = "Allow",
        Action   = [
          "sagemaker:CreateTrainingJob",
          "sagemaker:CreateModel",
          "sagemaker:CreateProcessingJob",
          "sagemaker:CreateNotebookInstance",
          "sagemaker:Describe*",
          "sagemaker:InvokeEndpoint"
        ],
        Resource = "*"
      }
    ]
  })
}

# Attach managed admin policy (optional for dev)
resource "aws_iam_role_policy_attachment" "sagemaker_admin_attach" {
  role       = aws_iam_role.sagemaker.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}