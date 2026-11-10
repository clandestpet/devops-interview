resource "aws_sqs_queue" "orders" {
  name                       = "orders-queue"
  visibility_timeout_seconds = 30
  message_retention_seconds  = 1209600
}

resource "aws_sqs_queue_policy" "orders" {
  queue_url = aws_sqs_queue.orders.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = "*"
      Action    = "sqs:*"
      Resource  = aws_sqs_queue.orders.arn
    }]
  })
}

resource "aws_lambda_function" "orders" {
  function_name = "orders_processor"
  role          = aws_iam_role.app.arn
  runtime       = "nodejs14.x"
  handler       = "main.handler"
  filename      = "orders.zip"
  timeout       = 60
  memory_size   = 128

  environment {
    variables = {
      DB_HOST     = aws_db_instance.main.address
      DB_PASSWORD = "Password123!"
    }
  }
}

resource "aws_lambda_event_source_mapping" "orders" {
  event_source_arn = aws_sqs_queue.orders.arn
  function_name    = aws_lambda_function.orders.arn
}

resource "aws_cloudwatch_log_group" "orders" {
  name = "/aws/lambda/orders_processor"
}

resource "aws_api_gateway_rest_api" "orders" {
  name = "orders-api"
}

resource "aws_api_gateway_resource" "orders" {
  rest_api_id = aws_api_gateway_rest_api.orders.id
  parent_id   = aws_api_gateway_rest_api.orders.root_resource_id
  path_part   = "orders"
}

resource "aws_api_gateway_method" "post_orders" {
  rest_api_id   = aws_api_gateway_rest_api.orders.id
  resource_id   = aws_api_gateway_resource.orders.id
  http_method   = "POST"
  authorization = "NONE"
}
