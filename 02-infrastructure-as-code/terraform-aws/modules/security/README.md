# Security Module

## Purpose

This module will manage security-related resources such as security groups and their rules.

Currently, this module is a **skeleton** and does not create any resources. It is intended to be extended with concrete security group and rule definitions.

## Planned Inputs

- `aws_project` – AWS project name.
- `aws_environment` – AWS environment (e.g. dev, stage, prod).
- `inbound_rules` – Map of inbound security rules to apply.
- `outbound_rules` – Map of outbound security rules to apply.

## Planned Outputs

- `security_group_ids` – IDs of security groups managed by this module once implemented.

## Relationships

This module is expected to be used by other modules such as VPC, ALB, and compute to apply consistent security group policies across resources once fully implemented.

