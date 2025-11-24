resource "aws_sagemaker_model" "model" {
  name               = "${var.env}-model"
  execution_role_arn = var.sagemaker_role_arn

  primary_container {
    image         = var.inference_image
    model_data_url = var.model_s3_path
  }
}

resource "aws_sagemaker_endpoint_configuration" "endpoint_config" {
  name = "${var.env}-endpoint-config"
  production_variants {
    variant_name = "AllTraffic"
    model_name   = aws_sagemaker_model.model.name
    instance_type = var.instance_type
    initial_instance_count = var.initial_instance_count
  }
}

resource "aws_sagemaker_endpoint" "endpoint" {
  name = "${var.env}-endpoint"
  endpoint_config_name = aws_sagemaker_endpoint_configuration.endpoint_config.name
}
