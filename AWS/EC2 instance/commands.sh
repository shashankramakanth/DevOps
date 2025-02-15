#generate key-pair
aws ec2 create-key-pair \
    --key-name my-key-pair \
    --query 'KeyMaterial' \
    --output text > my-key-pair.pem

#change permission
chmod 400 my-key-pair.pem

#launch instance
aws ec2 run-instances \
    --image-id ami-053a45fff0a704a47 \
    --count 1 \
    --instance-type t2.micro \
    --key-name my-key-pair \
    --security-group-ids <> \
    --subnet-id <> \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=MyEC2Instance}]'
    --user-data file://user-data.sh
#-------------------------------------------------------------------------------
#Optionally, you can create a security group and a user using the following commands:

#Create a security group with inbound rules
aws ec2 create-security-group \
    --group-name my-security-group \
    --description "Allow SSH and ICMP" \
    --vpc-id vpc-xxxxxx

#Add inbound rules to the security group
aws ec2 authorize-security-group-ingress \
    --group-name my-security-group \
    --protocol tcp --port 22 --cidr 0.0.0.0/0

aws ec2 authorize-security-group-ingress \
    --group-name my-security-group \
    --protocol icmp --port -1 --cidr 0.0.0.0/0    

#Create a user using cloud-init  - refer user-data.sh
