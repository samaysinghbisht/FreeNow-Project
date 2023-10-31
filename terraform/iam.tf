resource "aws_iam_role" "freenow_ec2_role" {
  name = "EC2-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "freenow_ec2_access_policy" {
  name = "EC2AccessPolicy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = "rds-db:connect",
        Effect   = "Allow",
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ],
        Resource = "arn:aws:s3:::freenow1234/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "freenow_ec2_access_attachment" {
  policy_arn = aws_iam_policy.freenow_ec2_access_policy.arn
  role       = aws_iam_role.freenow_ec2_role.name
}

resource "aws_iam_instance_profile" "freenow_ec2_instance_profile" {
  name = "EC2InstanceProfile"
  role = aws_iam_role.freenow_ec2_role.name
}