# Setup the MongoDB repo file
repo_file=$(pwd)
cp ${repo_file}/files/mongodb.repo /etc/yum.repos.d/mongo.repo

# Install MongoDB
yum install mongodb-org -y

# Start & Enable MongoDB Service
systemctl enable mongod
systemctl start mongod

# Update listen address from 127.0.0.1 to 0.0.0.0 in /etc/mongod.conf
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf

# Restart the service to make the changes effected
systemctl restart mongod
