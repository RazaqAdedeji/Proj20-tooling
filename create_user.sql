CREATE USER 'Admin'@'%' IDENTIFIED BY 'Admin.com';
GRANT ALL PRIVILEGES ON *.* TO 'Admin'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
