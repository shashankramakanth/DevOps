import boto3

def create_ec2_instance():
    # Create EC2 client
    ec2 = boto3.client('ec2',
        region_name='us-east-1',
        # aws_access_key_id='YOUR_ACCESS_KEY',
        # aws_secret_access_key='YOUR_SECRET_KEY'
    )
    
    try:
        # Launch EC2 instance
        response = ec2.run_instances(
            ImageId='ami-053a45fff0a704a47',  # Amazon Linux 2 AMI ID (update as needed)
            InstanceType='t2.micro',
            MinCount=1,
            MaxCount=1,
            KeyName='my-key-pair',  # Your SSH key pair name
            SecurityGroupIds=['sg-0f0e7e8c28fa50565'],  # Your security group ID
            TagSpecifications=[
                {
                    'ResourceType': 'instance',
                    'Tags': [
                        {
                            'Key': 'Name',
                            'Value': 'MyEC2Instance_claude'
                        }
                    ]
                }
            ]
        )
        
        instance_id = response['Instances'][0]['InstanceId']
        print(f"Instance created successfully. Instance ID: {instance_id}")
        return instance_id
        
    except Exception as e:
        print(f"Error creating EC2 instance: {str(e)}")
        return None

if __name__ == "__main__":
    create_ec2_instance()
