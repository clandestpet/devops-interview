resource "aws_sqs_queue" "orders" {
  name                       = "orders-queue"
  visibility_timeout_seconds = 360
}

resource "aws_sqs_queue_policy" "orders" {
  queue_url = aws_sqs_queue.orders.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { AWS = "arn:aws:iam::123456789012:role/orders-service" }
        Action    = "sqs:SendMessage"
        Resource  = aws_sqs_queue.orders.arn
      },
      {
        Effect    = "Deny"
        Principal = "*"
        Action    = "sqs:*"
        Resource  = aws_sqs_queue.orders.arn
        Condition = {
          StringNotEquals = {
            "aws:PrincipalArn" = "arn:aws:iam::123456789012:role/orders-service"
          }
        }
      }
    ]
  })
}

resource "aws_lambda_function" "orders_processor" {
  function_name = "orders_processor"
  role          = aws_iam_role.orders_processor.arn
  runtime       = "nodejs22.x"
  handler       = "main.handler"
  filename      = "orders.zip"
  timeout       = 60
}

resource "aws_lambda_event_source_mapping" "orders" {
  event_source_arn = aws_sqs_queue.orders.arn
  function_name    = aws_lambda_function.orders_processor.arn
}
