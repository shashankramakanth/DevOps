**Create a New IAM User**

1.	Create a new IAM user **without** admin permissions.

2.	Attach AmazonS3ReadOnlyAccess to the user.

3. Log in and verify you can view S3 buckets but not modify them.

4. Attach the role to an EC2 instance

5. Create an IAM role and attach it to an EC2 instance - test access.
    
    Test IAM role created will allow S2 full access
    Create a policy.json file
    Create an IAM role with policy definition
    Create a policy and attach it to IAM role
    Creat an instance profile for the role
    Attach instance profile to EC2 instance