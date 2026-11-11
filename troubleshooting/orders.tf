resource "aws_sqs_queue" "orders" {
  name                       = "orders-queue"
  visibility_timeout_seconds = 360
}

resource "aws_iam_role" "orders_api" {
  name = "orders-api"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Action    = "sts:AssumeRole"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })

  inline_policy {
    name = "send-orders"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [{
        Effect   = "Allow"
        Action   = "sqs:SendMessage"
        Resource = "arn:aws:sqs:us-east-1:123456789012:order-queue"
      }]
    })
  }
}

resource "aws_iam_role" "orders_processor" {
  name = "orders-processor"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Action    = "sts:AssumeRole"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })

  inline_policy {
    name = "read-orders"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [{
        Effect   = "Allow"
        Action   = ["sqs:SendMessage", "sqs:GetQueueAttributes"]
        Resource = "arn:aws:sqs:us-east-1:123456789012:orders-queue"
      }]
    })
  }
}
