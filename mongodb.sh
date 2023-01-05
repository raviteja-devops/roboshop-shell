# Setup the MongoDB repo file
repo_file=$(pwd)
cp ${repo_file}/files/mongodb.repo /etc/yum.repos.d/mongo.repo

# Install MongoDB
echo -e "\e[35m Install MongoDB\e[0m"
yum install mongodb-org -y

# Start & Enable MongoDB Service
echo -e "\e[35m Enable and Start MongoDB\e[0m"
systemctl enable mongod
systemctl start mongod

# Update listen address from 127.0.0.1 to 0.0.0.0 in /etc/mongod.conf
echo -e "\e[35m Change IP in Conf File\e[0m"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf

# Restart the service to make the changes effected
echo -e "\e[35m Restart MongoDB\e[0m"
systemctl restart mongod
