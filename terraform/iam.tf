# ============================================================
# EC2 IAM Role
# ============================================================

resource "aws_iam_role" "ec2_role" {
  name = "8byte-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecr_read_only" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "8byte-ec2-profile"
  role = aws_iam_role.ec2_role.name
}


# ============================================================
# GitHub Actions OIDC Provider
# ============================================================

resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1"
  ]
}


# ============================================================
# GitHub Actions IAM Role
# ============================================================

resource "aws_iam_role" "github_actions" {
  name        = "8byte-github-actions-role"
  description = "Role for GitHub Actions CI/CD deployment"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }

        Action = "sts:AssumeRoleWithWebIdentity"

        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }

          StringLike = {
            "token.actions.githubusercontent.com:sub" = [
              "repo:trinetra914@125327243/8byte-devops-assignment@1349637084:ref:refs/heads/main",
              "repo:trinetra914@125327243/8byte-devops-assignment@1349637084:environment:staging",
              "repo:trinetra914@125327243/8byte-devops-assignment@1349637084:environment:production"
            ]
          }
        }
      }
    ]
  })
}


# ============================================================
# GitHub Actions IAM Policy
# ============================================================

resource "aws_iam_role_policy" "github_actions" {
  name = "8byte-github-actions-policy"
  role = aws_iam_role.github_actions.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [

      # ------------------------------------------------------
      # ECR Permissions
      # ------------------------------------------------------

      {
        Sid    = "ECRAuthorization"
        Effect = "Allow"

        Action = [
          "ecr:GetAuthorizationToken"
        ]

        Resource = "*"
      },

      {
        Sid    = "ECRPush"
        Effect = "Allow"

        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart",
          "ecr:BatchGetImage"
        ]

        Resource = aws_ecr_repository.app.arn
      },

      # ------------------------------------------------------
      # SSM Deployment Permissions
      # ------------------------------------------------------

      {
        Sid    = "SSMDeployment"
        Effect = "Allow"

        Action = [
          "ssm:SendCommand",
          "ssm:GetCommandInvocation",
          "ssm:ListCommandInvocations",
          "ssm:ListCommands"
        ]

        Resource = "*"
      },

      # ------------------------------------------------------
      # EC2 Describe Permissions
      # ------------------------------------------------------

      {
        Sid    = "EC2Describe"
        Effect = "Allow"

        Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceStatus"
        ]

        Resource = "*"
      }
    ]
  })
}