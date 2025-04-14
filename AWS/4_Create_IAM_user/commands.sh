#1. Create IAM user
aws iam create-user --user-name aws-cli-user1

#2.Create an IAM role with S3 full access
aws iam create-role --role-name EC2-S3-FullAccess-Role --assume-role-policy-document file://policy.json

#3. Attach the policy to the role
aws iam attach-role-policy --role-name EC2-S3-FullAccess-Role --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess

#4. Create an instance profile
aws iam create-instance-profile --instance-profile-name EC2-S3-FullAccess-Role

#5. Attach the role to an EC2 instance
aws ec2 associate-iam-instance-profile --instance-id <> --iam-instance-profile Name=EC2-S3-FullAccess-Role

#6. Assign temporary password with password reset required
aws iam create-login-profile --user-name awsadmin --password "TemporaryPassword123!" --password-reset-required

#7. Create an IAM user and add to admin group
aws iam create-user --user-name awsadmin && aws iam add-user-to-group --user-name awsadmin -
-group-name admin && aws iam create-login-profile --user-name awsadmin --password "TemporaryPassword123" --password-reset-required
