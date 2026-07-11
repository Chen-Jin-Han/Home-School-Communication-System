@echo off
chcp 65001 >nul
echo === MySQL Root Password Reset - MUST run as Administrator ===
echo.
echo Step 1: Stop MySQL service
net stop MySQL84
echo.
echo Step 2: Start MySQL with password reset (wait 5 seconds then press Ctrl+C)...
"C:\Program Files\MySQL\MySQL Server 8.4\bin\mysqld.exe" --init-file=C:/Users/95925/DevEcoStudioProjects/final/backend/reset_pwd.sql --console
echo.
echo Step 3: Restart MySQL service
net start MySQL84
echo.
echo Done! Password is now: root
pause
