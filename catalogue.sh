repo_file=$(pwd)

# Setup NodeJS repos. Vendor is providing a script to setup the repos
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

# Install NodeJS
yum install nodejs -y

# Add application User
# User roboshop is a function / daemon user to run the application.
# Apart from that we dont use this user to login to server.
useradd roboshop

# Lets setup an app directory
mkdir /app

# Download the application code to created app directory
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app
unzip /tmp/catalogue.zip

# Lets download the dependencies
cd /app
npm install

# Load the service
systemctl daemon-reload

# Start the service
systemctl enable catalogue
systemctl start catalogue

# Setup the MongoDB repo file
cp ${repo_file}/files/mongodb.repo /etc/yum.repos.d/mongo.repo

# Install MongoDB
yum install mongodb-org-shell -y

# Load Schema
