UPDATE mysql.user SET authentication_string='' WHERE User='root' AND Host='localhost';
FLUSH PRIVILEGES;
