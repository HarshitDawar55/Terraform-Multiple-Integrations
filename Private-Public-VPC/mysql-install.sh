#! /bin/bash
"sudo yum update -y",
"sudo yum install mysql php-mysqlnd -y",
"sudo systemctl start mysqld",
"sudo systemctl enable mysqld"
