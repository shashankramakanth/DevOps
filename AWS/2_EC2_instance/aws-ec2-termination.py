import boto3
import sys

def terminate_ec2_instances(instance_ids):
    try:
        # Create EC2 client
        ec2 = boto3.client('ec2')
        
        # List instance details before confirmation
        print("\nInstances to be terminated:")
        for instance_id in instance_ids:
            try:
                response = ec2.describe_instances(InstanceIds=[instance_id])
                for reservation in response['Reservations']:
                    for instance in reservation['Instances']:
                        name = next((tag['Value'] for tag in instance.get('Tags', []) if tag['Key'] == 'Name'), 'No Name')
                        print(f"ID: {instance_id}, Name: {name}, State: {instance['State']['Name']}")
            except Exception as e:
                print(f"Warning: Could not fetch details for instance {instance_id}: {str(e)}")
        
        # Confirm with user
        confirm = input(f"\nAre you sure you want to terminate {len(instance_ids)} instance(s)? (yes/no): ")
        if confirm.lower() != 'yes':
            print("Termination cancelled")
            return False
        
        # Terminate the instances
        response = ec2.terminate_instances(InstanceIds=instance_ids)
        
        # Print initial termination status for each instance
        print("\nInitiating termination:")
        for instance in response['TerminatingInstances']:
            print(f"Instance {instance['InstanceId']} status: {instance['CurrentState']['Name']}")
        
        # Wait for all instances to be terminated
        print("\nWaiting for instances to be terminated...")
        waiter = ec2.get_waiter('instance_terminated')
        waiter.wait(
            InstanceIds=instance_ids,
            WaiterConfig={'Delay': 30, 'MaxAttempts': 20}
        )
        
        print("\nAll specified instances have been successfully terminated")
        return True
        
    except Exception as e:
        print(f"\nError during termination process: {str(e)}")
        return False

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python script.py <instance-id-1> [instance-id-2] [instance-id-3] ...")
        print("Example: python script.py i-1234567890abcdef0 i-0987654321fedcba0")
        sys.exit(1)
    
    instance_ids = sys.argv[1:]
    terminate_ec2_instances(instance_ids)
