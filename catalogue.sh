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
mkdir -p /app

rm -rf /app/*

# Download the application code to created app directory
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app
unzip /tmp/catalogue.zip

# Lets download the dependencies
cd /app
npm install

# Setup SystemD Catalogue Service
cp ${repo_file}/files/catalogue.service /etc/systemd/system/catalogue.service

# Load the service
systemctl daemon-reload

# Start the service
systemctl enable catalogue
systemctl start catalogue

# We need to load the schema. To load schema we need to install mongodb client
# To have it installed we can setup MongoDB repo and install mongodb-client
cp ${repo_file}/files/mongodb.repo /etc/yum.repos.d/mongo.repo

# Install MongoDB client
yum install mongodb-org-shell -y

# Load Schema
mongo --host localhost </app/schema/catalogue.js