resource "aws_iam_user" "example_user" {
    name = "Syed-user"
  
}
resource "aws_iam_policy" "s3_read_policy" {
  name        = "S3ReadAccess"
  description = "Allow read-only access to S3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["s3:GetObject", "s3:ListBucket"]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}
resource "aws_iam_user_policy_attachment" "user_policy_attach" {
  user       = aws_iam_user.example_user.name
  policy_arn = aws_iam_policy.s3_read_policy.arn
}
resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}
resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
resource "aws_iam_role_policy" "custom_policy" {
  name = "CustomS3Access"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["s3:PutObject"]
      Resource = "arn:aws:s3:::my-bucket/*"
    }]
  })
}



# For example, in a 3-tier app:

# Backend EC2 instance → needs a role to access RDS.

# Lambda → needs a role to access DynamoDB.

# Admin user → needs a policy to manage S3.

# Terraform helps you manage all these IAM permissions consistently
