# Compute Module

## Purpose

This module will manage compute-layer resources such as EC2 instances or Auto Scaling Groups.

Currently, this module is a **skeleton** and does not create any resources. It is intended to be extended with concrete compute resources.

## Planned Inputs

- `aws_project` – AWS project name.
- `aws_environment` – AWS environment (e.g. dev, stage, prod).
- `subnet_ids` – List of subnet IDs where compute resources will be created.
- `instance_type` – Instance type for compute resources.

## Planned Outputs

- `compute_resource_ids` – IDs of compute resources (e.g. EC2 instances or ASG) once implemented.

## Relationships

This module is expected to consume VPC outputs (subnets, possibly security groups) and may be used in conjunction with the ALB and security modules once fully implemented.

