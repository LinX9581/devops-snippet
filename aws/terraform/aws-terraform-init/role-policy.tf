# 建立一個 EC2 Role
resource "aws_iam_role" "ec2_role" {
  name = "ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com",
        },
        Action = "sts:AssumeRole",
      },
    ],
  })
}

# 綁定已建立的 Policy 到 Role 上
resource "aws_iam_role_policy_attachment" "s3_ssm_policy_attachment" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.s3_ssm_policy.arn
}

# 建立一個 EC2 Profile 並綁定 Role
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-proflie"
  role = aws_iam_role.ec2_role.name
}

# 建立一個 Policy 並設定 S3 和 SSM 的權限
resource "aws_iam_policy" "s3_ssm_policy" {
  name        = "S3AndSSMReadOnlyPolicy"
  path        = "/"
  description = "Policy that grants access to S3 and SSM."

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "s3:Get*",
          "s3:List*",
          "s3:Put*",
          "s3:DeleteObject",
          "s3:CreateBucket",
          "s3:DeleteBucket",
        ],
        Resource = "*"
      },
      {
        Effect   = "Allow",
        Action   = [
          "ssm:GetParameters",
          "ssm:GetParameter",
          "ssm:DescribeParameters",
          "ssm:GetParameterHistory",
          "ssm:ListTagsForResource"
        ],
        Resource = "*"
      }
    ]
  })
}
