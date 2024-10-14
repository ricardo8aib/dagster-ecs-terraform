resource "aws_iam_role" "sfn_execution_role" {
  name = var.DATASYNC_STATE_MACHINE_EXECUTION_ROLE_NAME

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "states.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role" "eventbridge_target_execution_role" {
  name = var.DATASYNC_EVENTBRIDGE_TARGET_EXECUTION_ROLE_NAME

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Effect": "Allow",
          "Principal": {
              "Service": "events.amazonaws.com"
          },
          "Action": "sts:AssumeRole"
      }
  ]
}
POLICY
}

resource "aws_iam_role_policy" "sfn_policy" {
  name = var.STEP_FUNCTION_EXECUTION_POLICY_NAME
  role = aws_iam_role.sfn_execution_role.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "datasync:StartTaskExecution",
      "Resource": "${var.DATASYNC_TASK_ARN}"
    },
    {
      "Effect": "Allow",
      "Action": "logs:*",
      "Resource": "arn:aws:logs:*:*:*"
    },
    {
      "Effect": "Allow",
      "Action": "states:StartExecution",
      "Resource": "${aws_sfn_state_machine.datasync_state_machine.arn}"
    },
    {
      "Effect": "Allow",
      "Action": "ec2:DescribeNetworkInterfaces",
      "Resource": "*"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy" "eventbridge_target_excution_policy" {
  name = var.EVENTBRIDGE_TARGET_EXECUTION_POLICY_NAME
  role = aws_iam_role.eventbridge_target_execution_role.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "states:StartExecution",
      "Resource": "${aws_sfn_state_machine.datasync_state_machine.arn}"
    }
  ]
}
POLICY
}
