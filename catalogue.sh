repo_file=$(pwd)

# Setup NodeJS repos. Vendor is providing a script to setup the repos
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

# Install NodeJS
echo -e "\e[35m Install NodeJS\e[0m"
yum install nodejs -y

# Add application User
# User roboshop is a function / daemon user to run the application.
# Apart from that we dont use this user to login to server.
echo -e "\e[35m Add User\e[0m"
useradd roboshop

# Lets setup an app directory
echo -e "\e[35m Create Directory\e[0m"
mkdir -p /app

echo -e "\e[35m Removing Existing Files\e[0m"
rm -rf /app/*

# Download the application code to created app directory
echo -e "\e[35m Download The Application Code and Unzip\e[0m"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app
unzip /tmp/catalogue.zip

# Lets download the dependencies
echo -e "\e[35m Install Dependencies\e[0m"
cd /app
npm install

# Setup SystemD Catalogue Service
echo -e "\e[35m Setup Catalogue Service\e[0m"
cp ${repo_file}/files/catalogue.service /etc/systemd/system/catalogue.service

# Load the service
echo -e "\e[35m Load Service\e[0m"
systemctl daemon-reload

# Start the service
echo -e "\e[35m Enable and Start Service\e[0m"
systemctl enable catalogue
systemctl start catalogue

# We need to load the schema. To load schema we need to install mongodb client
# To have it installed we can setup MongoDB repo and install mongodb-client
cp ${repo_file}/files/mongodb.repo /etc/yum.repos.d/mongo.repo

# Install MongoDB client
echo -e "\e[35m Install MongoDB Client\e[0m"
yum install mongodb-org-shell -y

# Load Schema
echo -e "\e[35m Load Schema\e[0m"
mongo --host mongodb-dev.raviteja.online </app/schema/catalogue.js