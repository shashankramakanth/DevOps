# ALB Module

## Purpose

This module will manage AWS Application Load Balancer (ALB) resources.

Currently, this module is a **skeleton** and does not create any resources. It is intended to be extended with concrete ALB resources such as load balancers, listeners, and target groups.

## Planned Inputs

- `aws_project` – AWS project name.
- `aws_environment` – AWS environment (e.g. dev, stage, prod).
- `vpc_id` – ID of the VPC where the ALB will be created.
- `subnet_ids` – List of subnet IDs to attach to the ALB.

## Planned Outputs

- `alb_arn` – ARN of the Application Load Balancer (to be defined once resources are implemented).

## Relationships

This module is expected to consume VPC-related outputs (such as subnet IDs) and may be referenced by compute and security modules for routing and security group configuration once fully implemented.

