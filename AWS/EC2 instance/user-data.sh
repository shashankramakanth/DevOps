#!/bin/bash
# Define your custom username
USERNAME="mycustomuser"

# Create the user
useradd -m -s /bin/bash $USERNAME

# Add the user to the sudo group (for Ubuntu use 'sudo' instead of 'wheel')
usermod -aG wheel $USERNAME

# Set up SSH access using the same key-pair as ec2-user
mkdir -p /home/$USERNAME/.ssh
cp /home/ec2-user/.ssh/authorized_keys /home/$USERNAME/.ssh/
chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh
chmod 700 /home/$USERNAME/.ssh
chmod 600 /home/$USERNAME/.ssh/authorized_keys

# Allow SSH login for the new user
echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USERNAME