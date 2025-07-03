# Terraform Docker Environment with Persistent Storage

This project provides a Docker-based Terraform environment with persistent storage, allowing you to maintain your Terraform state and configuration between container restarts.

## Features

- **Persistent Storage**: All Terraform files and state are preserved
- **Custom Terraform Image**: Alpine-based image with Terraform pre-installed
- **AWS CLI Included**: AWS CLI is pre-installed for credential verification and AWS operations
- **AWS Integration**: Mount your AWS credentials or use environment variables
- **Developer Tools**: Includes common tools like git, jq, vim, and nano
- **Version Controlled**: Designed to work well with Git (includes .gitignore)

## Prerequisites

- [Docker](https://www.docker.com/products/docker-desktop) installed on your Mac
- [Docker Compose](https://docs.docker.com/compose/install/) (included with Docker Desktop for Mac)
- AWS credentials (if working with AWS resources)

## Directory Structure

```
terraform-docker-sso/
├── Dockerfile                # Defines the Terraform container image
├── docker-compose.yml        # Orchestrates the container setup
├── connect.sh                # Helper script to connect to the container
├── disconnect.sh             # Helper script to stop the container
├── .gitignore                # Prevents committing sensitive files
└── terraform-data/           # Persistent storage for Terraform files
    └── main.tf               # Example Terraform configuration
```

## Quick Start

1. **Clone this repository**
   ```bash
   git clone <repository-url>
   cd terraform-docker-sso
   ```

2. **Build and start the container**
   ```bash
   docker-compose up -d
   ```

3. **Connect to the container**
   ```bash
   ./connect.sh
   # Or directly with:
   docker-compose exec terraform bash
   ```

4. **Initialize Terraform (inside the container)**
   ```bash
   terraform init
   ```

5. **Run Terraform commands (inside the container)**
   ```bash
   terraform plan
   terraform apply
   ```

## AWS Authentication Options

### Option 1: Environment Variables

Before starting the container, set your AWS credentials as environment variables:

```bash
export AWS_ACCESS_KEY_ID=your_access_key
export AWS_SECRET_ACCESS_KEY=your_secret_key
export AWS_SESSION_TOKEN=your_session_token  # If using temporary credentials
```

Then start the container:
```bash
docker-compose up -d
```

### Option 2: AWS CLI Profiles

The container mounts your `~/.aws` directory, so you can use AWS profiles:

1. Configure AWS CLI on your Mac:
   ```bash
   aws configure
   # Or for a specific profile
   aws configure --profile myprofile
   ```

2. Inside the container, use the profile:
   ```bash
   export AWS_PROFILE=myprofile
   terraform apply
   ```

### Option 3: AWS SSO

If your organization uses AWS SSO:

1. Configure AWS SSO on your Mac:
   ```bash
   aws configure sso
   aws sso login --profile your-sso-profile
   ```

2. Export the credentials to environment variables:
   ```bash
   eval "$(aws configure export-credentials --profile your-sso-profile --format env)"
   ```

3. Start or restart the container:
   ```bash
   docker-compose up -d
   ```

## connect.sh Script

The `connect.sh` script is used to log in to AWS SSO, export credentials, start the Terraform container, and connect to it.

### Usage

```bash
./connect.sh <aws_profile>
```

- `<aws_profile>`: The AWS profile to use for SSO login and exporting credentials.

### Example

```bash
./connect.sh vscode-aws-profile1
```

This will:
1. Log in to AWS SSO using the `vscode-aws-profile1` profile.
2. Export the credentials for the specified profile.
3. Start the Terraform container using `docker-compose up -d`.
4. Connect to the Terraform container.

## disconnect.sh Script

The `disconnect.sh` script is used to stop the Terraform container.

### Usage

```bash
./disconnect.sh
```

This will:
1. Check if the Terraform container is running.
2. Stop the container if it is running.

### Example

```bash
./disconnect.sh
```

If the container is not running, the script will notify you that no action is needed.

## Customization

### Changing Terraform Version

Edit the `Dockerfile` and change the `TERRAFORM_VERSION` environment variable:

```dockerfile
ENV TERRAFORM_VERSION="1.7.0"
```

Then rebuild the container:
```bash
docker-compose build
```

### Adding Additional Tools

Edit the `Dockerfile` and add more packages to the `apk add` command:

```dockerfile
RUN apk add --update --no-cache \
    curl \
    bash \
    openssh \
    git \
    jq \
    vim \
    nano \
    unzip \
    your-additional-package
```

## Best Practices

1. **State Management**
   - For team environments, configure a remote backend (S3, Azure Storage, etc.)
   - Example in main.tf (uncomment and configure):
     ```hcl
     terraform {
       backend "s3" {
         bucket = "my-terraform-state"
         key    = "terraform.tfstate"
         region = "us-west-2"
       }
     }
     ```

2. **Security**
   - Never commit .tfstate files to Git (they're excluded in .gitignore)
   - Use environment variables or AWS profiles instead of hardcoded credentials
   - Consider using IAM roles with minimum required permissions

3. **Module Organization**
   - For complex projects, organize resources into modules
   - Store reusable modules in separate Git repositories

## Troubleshooting

### Container Won't Start

Check for Docker errors:
```bash
docker-compose logs
```

### AWS Authentication Issues

Verify your credentials are set correctly:
```bash
# Inside the container
env | grep AWS
aws sts get-caller-identity
```

### Permission Issues

Ensure your AWS credentials have sufficient permissions for the resources you're trying to manage.
