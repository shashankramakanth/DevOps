---
# Terraform S3 Bucket Infrastructure

This Terraform configuration creates an S3 bucket with versioning enabled and a random suffix to ensure uniqueness.

## Infrastructure Overview

The configuration deploys:
- **S3 Bucket**: A uniquely named bucket with versioning enabled
- **Random Suffix**: Ensures bucket name uniqueness across AWS
- **Bucket Versioning**: Enables version control for objects in the bucket

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- [AWS CLI](https://aws.amazon.com/cli/) configured with appropriate credentials
- AWS account with S3 permissions

## AWS Provider Version

This configuration uses AWS Provider version `~> 3.0`. The exact version is locked in `.terraform.lock.hcl`.

## Configuration Files

- `main.tf` - Main Terraform configuration
- `variables.tf` - Variable definitions
- `.terraform.lock.hcl` - Provider version lock file (commit this to version control)

## Variables

| Variable | Description | Type | Default | Required |
|----------|-------------|------|---------|----------|
| `aws_region` | AWS region where resources will be created | `string` | `us-east-1` | No |
| `bucket_name` | Base name for the S3 bucket (random suffix will be appended) | `string` | `my-terraform-bucket` | No |

## Usage

### 1. Initialize Terraform
```bash
terraform init
```

### 2. Review the plan
```bash
terraform plan
```

### 3. Apply the configuration
```bash
terraform apply
```

### 4. Verify deployment
After successful deployment, note the actual bucket name from the output (it will include the random suffix).

## Customization

You can customize the deployment by:

1. **Changing the region:**
   ```bash
   terraform apply -var="aws_region=us-west-2"
   ```

2. **Using a custom bucket name:**
   ```bash
   terraform apply -var="bucket_name=my-custom-bucket"
   ```

3. **Using a terraform.tfvars file:**
   ```hcl
   aws_region = "eu-west-1"
   bucket_name = "my-company-bucket"
   ```

## Resources Created

- `aws_s3_bucket` - S3 bucket with unique name
- `aws_s3_bucket_versioning` - Enables versioning on the bucket
- `random_string` - Generates 8-character random suffix

## Bucket Configuration

- **Versioning**: Enabled
- **Force Destroy**: Disabled (protects against accidental deletion)
- **Tags**: 
  - Name: `my-terraform-bucket-unique101`
  - Environment: `Dev`
  - CreatedBy: `Terraform`

## Clean Up

To destroy the created resources:
```bash
terraform destroy
```

**Note**: If the bucket contains objects, you may need to empty it first or set `force_destroy = true` in the configuration.

## Team Collaboration

1. **State Management**: Configure remote state backend for team collaboration
2. **Lock File**: The `.terraform.lock.hcl` file is committed to ensure consistent provider versions
3. **Version Control**: All team members should run `terraform init` after pulling changes

## Security Considerations

- Ensure AWS credentials are properly configured and not hardcoded
- Review IAM permissions for the AWS user/role used by Terraform
- Consider enabling S3 bucket encryption for sensitive data
- Review bucket policies and access controls as needed

## Troubleshooting

- If bucket name conflicts occur, the random suffix should resolve them
- Ensure your AWS credentials have sufficient S3 permissions
- Check that the specified region is available in your AWS account


*This README was generated with assistance from AI and reviewed for accuracy.*