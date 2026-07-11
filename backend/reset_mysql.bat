@echo off
echo === MySQL Password Reset ===
net stop MySQL84
echo.
"C:\Program Files\MySQL\MySQL Server 8.4\bin\mysqld" --defaults-file="C:/ProgramData/MySQL/my.ini" --init-file=C:/mysql_tmp/reset.sql --console
echo.
echo Press Ctrl+C, then: net start MySQL84
echo Password is now: root
pause
