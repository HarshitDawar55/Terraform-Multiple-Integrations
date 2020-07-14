#! /bin/bash
"sudo yum update -y",
"sudo yum install mysql php-mysqlnd -y",
"sudo systemctl start mysqld",
"sudo systemctl enable mysqld",
"sudo mysql",
"create database wordpress",
"grant all on wordpress.* to wordpressUser@'localhost' identified by 'wordpressPassword';",
"flush privileges;"
