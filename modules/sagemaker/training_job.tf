resource "aws_sagemaker_training_job" "training" {
  name     = "${var.env}-training-job-${random_string.suffix.result}"
  role_arn = var.sagemaker_role_arn

  algorithm_specification {
    training_image      = var.training_image
    training_input_mode = "File"
  }

  input_data_config {
    channel_name = "training"
    data_source {
      s3_data_source {
        s3_data_type = "S3Prefix"
        s3_uri       = var.training_s3_uri
      }
    }
  }

  output_data_config {
    s3_output_path = var.output_s3_uri
  }

  resource_config {
    instance_type  = var.training_instance_type
    instance_count = var.training_instance_count
    volume_size_gb = var.volume_size_gb
  }

  stopping_condition {
    max_runtime_in_seconds = var.max_runtime_seconds
  }
}
