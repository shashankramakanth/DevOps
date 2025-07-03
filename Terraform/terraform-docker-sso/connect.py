#!/usr/bin/env python3
import sys
import subprocess
import os


def run_command(cmd, env=None, capture_output=False):
    try:
        result = subprocess.run(cmd, shell=True, check=True, text=True, env=env, capture_output=capture_output)
        return result.stdout if capture_output else None
    except subprocess.CalledProcessError as e:
        print(f"Command failed: {cmd}")
        if e.stdout:
            print(e.stdout)
        if e.stderr:
            print(e.stderr)
        sys.exit(1)

def main():
    if len(sys.argv) != 3:
        print(f"Usage: {sys.argv[0]} <aws_profile> <aws_region>")
        sys.exit(1)

    aws_profile = sys.argv[1]
    aws_region = sys.argv[2]

    # AWS SSO login
    print(f"Logging in to AWS SSO for profile {aws_profile}...")
    run_command(f"aws sso login --profile {aws_profile}")

    # Export AWS credentials
    print(f"Exporting AWS credentials for profile {aws_profile}...")
    creds_env = run_command(f"aws configure export-credentials --profile {aws_profile} --format env", capture_output=True)
    if not creds_env:
        print("Failed to export AWS credentials. Please check your AWS configuration.")
        sys.exit(1)
    # Parse and set credentials in os.environ
    for line in creds_env.strip().splitlines():
        if line.startswith('export '):
            keyval = line[len('export '):].split('=', 1)
            if len(keyval) == 2:
                key, val = keyval
                os.environ[key] = val.strip('"')

    # Export AWS region
    os.environ['AWS_REGION'] = aws_region
    print(f"AWS Region set to: {aws_region}")

    # Check if the terraform container is running
    print("Checking if Terraform container is running...")
    container_id = run_command("docker-compose ps -q terraform", capture_output=True)
    if not container_id.strip():
        print("Terraform container is not running. Starting it now...")
        run_command("docker-compose up -d")
    else:
        print("Terraform container is already running.")

    # Connect to the terraform container
    print("Connecting to Terraform container...")
    try:
        subprocess.run(["docker-compose", "exec", "terraform", "bash"], check=True)
    except subprocess.CalledProcessError:
        print("Failed to connect to Terraform container.")
        print("Please make sure:")
        print("1. Docker is running")
        print("2. You're in the correct directory with docker-compose.yml")
        print("3. Try running 'docker-compose up -d' first")
        sys.exit(1)

if __name__ == "__main__":
    main() 