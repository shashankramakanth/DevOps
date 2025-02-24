#Create an S3 bucket using AWS CLI
#If region is us-east-1
aws s3api create-bucket --bucket my-bucket-name --region us-east-1

#If other regions
aws s3api create-bucket --bucket my-bucket-name --region ap-south-1 --create-bucket-configuration LocationConstraint=ap-south-1

#List all S3 buckets
aws s3 ls

