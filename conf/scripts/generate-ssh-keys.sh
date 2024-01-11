#!/bin/bash

# Specify ssh-key file to check
file="/home/ec2-user/.ssh/id_rsa.pub"

# Check if the file exists and stop if yes
if [ -f "$file" ]; then
    echo "$file exists."
    while true; do
        echo "SSH-Keys seems to exist already!"
        read -p "Do you want to continue and overwrite them?(y/n) " yn
        case $yn in
            [Yy]* ) echo "Continuing ssh-file generation..." && break;;
            [Nn]* ) echo "Exit, this is the content of the existing public ssh-file:" && echo "---" && cat /home/ec2-user/.ssh/id_rsa.pub && exit;;
            * ) echo "Please answer yes or no.";;
        esac
    done
fi

# Remove old ssh-keys
if [ -f "$file" ]; then
sudo -i -u ec2-user bash <<-EOL
   rm ~/.ssh/id_rsa.pub
   rm ~/.ssh/id_rsa
EOL
fi

# Generate new ssh-key files
echo "---"
sudo -i -u ec2-user bash <<-EOL
  ssh-keygen -t rsa -b 4096 -C "$EMAIL" -f ~/.ssh/id_rsa -N ""
  cat ~/.ssh/id_rsa.pub
EOL

echo "---"
echo "To add access to your Github repository follow these steps:"
echo "1. Visit your user profile setting page: https://github.com/settings/profile"
echo "2. Go to: 'SSH and GPG key' and add the generated ssh-rsa key (see above)."
echo "3. Make sure the git remote origin is pointing to the SSH connection string on your remote machine."
