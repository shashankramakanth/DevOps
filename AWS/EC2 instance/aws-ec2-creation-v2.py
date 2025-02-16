import boto3

# Initialize EC2 client
ec2 = boto3.client("ec2", region_name="us-east-1")  # Change the region if needed

# Create an EC2 instance
response = ec2.run_instances(
    ImageId="ami-053a45fff0a704a47",  # Amazon Linux AMI (change if needed)
    InstanceType="t2.micro",
    KeyName="my-key-pair",  # Make sure this key-pair exists
    MinCount=1,
    MaxCount=1,
    SecurityGroupIds=["sg-0f0e7e8c28fa50565"],  # Replace with your security group ID
    SubnetId="subnet-09c2cbe40e7e52f34",  # Replace with your subnet ID
    TagSpecifications=[
        {
            "ResourceType": "instance",
            "Tags": [{"Key": "Name", "Value": "MyEC2Instance"}],
        }
    ],
)

# Get instance ID
instance_id = response["Instances"][0]["InstanceId"]
print(f"EC2 Instance Created: {instance_id}")