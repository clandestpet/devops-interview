provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAIOSFODNN7EXAMPLE"
  secret_key = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
}

resource "aws_s3_bucket" "uploads" {
  bucket = "acme-customer-uploads"
  acl    = "public-read"
}

resource "aws_security_group" "app" {
  name = "app-sg"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "main" {
  engine                  = "mysql"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  username                = "admin"
  password                = "Password123!"
  publicly_accessible     = true
  storage_encrypted       = false
  backup_retention_period = 0
  skip_final_snapshot     = true
}

resource "aws_iam_policy" "app" {
  name = "app-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "*"
      Resource = "*"
    }]
  })
}

resource "aws_iam_role" "app" {
  name = "app-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Action    = "sts:AssumeRole"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "app" {
  role       = aws_iam_role.app.name
  policy_arn = aws_iam_policy.app.arn
}
