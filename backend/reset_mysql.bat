@echo off
echo === MySQL Password Reset ===
echo MUST run as Administrator!
echo.
net stop MySQL84
echo Starting safe mode...
start "mysql-reset" "C:\Program Files\MySQL\MySQL Server 8.4\bin\mysqld" --skip-grant-tables --skip-networking
timeout /t 5 /nobreak >nul
echo Resetting password to empty...
"C:\Program Files\MySQL\MySQL Server 8.4\bin\mysql" -u root -e "UPDATE mysql.user SET authentication_string='' WHERE User='root'; FLUSH PRIVILEGES;"
taskkill /f /im mysqld.exe >nul 2>&1
timeout /t 2 /nobreak >nul
net start MySQL84
echo.
echo Now connect with empty password: mysql -u root
echo Then run: ALTER USER 'root'@'localhost' IDENTIFIED BY 'root';
pause
