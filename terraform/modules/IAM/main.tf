  # Roles
resource "aws_iam_role" "datasync_role" {
  name = var.DATASYNC_ROLE_NAME

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "datasync.amazonaws.com"
      }
    }
  ]
}
POLICY
}


resource "aws_iam_role" "ecs_task_execution_role" {
  name = var.ECS_ROLE_NAME
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}


# Policies
resource "aws_iam_role_policy" "datasync_role_policy" {
  name = var.DATASYNC_POLICY_NAME
  role = aws_iam_role.datasync_role.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": [
        "${var.CODE_LOCATION_BUCKET_ARN}/*",
        "${var.CODE_LOCATION_BUCKET_ARN}"
      ]
    },
    {
      "Action": [
        "efs:*"
      ],
      "Effect": "Allow",
      "Resource": "${var.EFS_ARN}"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy" "ecs_task_policy" {
  name        = var.ECS_POLICY_NAME
  role        = aws_iam_role.ecs_task_execution_role.id
  
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:CreateLogGroup"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:BatchCheckLayerAvailability"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "elasticfilesystem:*"
      ],
      "Resource": "${var.EFS_ARN}"
    },
    {
			"Effect": "Allow",
			"Action": [
				"ecs:*"
			],
			"Resource": [
				"*"
			]
		},
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeNetworkInterfaces"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "iam:PassRole"
      ],
      "Resource": "${aws_iam_role.ecs_task_execution_role.arn}"
    }
  ]
}
POLICY
}

# Attach the AmazonECSTaskExecutionRolePolicy to the role
resource "aws_iam_role_policy_attachment" "attach_ecs_task_execution_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}