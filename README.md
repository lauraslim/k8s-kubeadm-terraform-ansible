# k8s-kubeadm-terraform-ansible

# Installing tools on ubuntu
# Installing Terraform
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common

wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

gpg --no-default-keyring \
--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
--fingerprint

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update
sudo apt-get install terraform
# verify
 terraform -help
 terraform -help plan

 # install ansible

sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible

# update path

# or
sudo apt install python3 python3-pip
pip3 install ansible

# update path: WARNING: The scripts ansible, ansible-config, ansible-connection, ansible-console, ansible-doc, ansible-galaxy, ansible-inventory, ansible-playbook, ansible-pull and ansible-vault are installed in '/home/laura/.local/bin' which is not on PATH.
# Consider adding this directory to PATH or, if you prefer to suppress this warning, use --no-warn-script-location.
# WARNING: The script ansible-community is installed in '/home/laura/.local/bin' which is not on PATH.
# Consider adding this directory to PATH

   echo "export PATH=$PATH:/home/laura/.local/bin" >> ~/.bashrc
   source ~/.bashrc
   ansible --version

# Installing Git
yum install git -y


# install aws cli 
sudo snap install aws-cli --classic
 aws --version
# Configure AWS CLI
aws configure