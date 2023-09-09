@echo off
echo Cleaning temporary files...
:: Remove files from the user's temp folder
del /q %temp%\*.*
:: Remove files from the Windows temp folder (system-wide)
del /q C:\Windows\Temp\*.*

:: Optionally, you can add more directories to clean up, such as browser cache folders
:: del /q "C:\Users\%username%\AppData\Local\Google\Chrome\User Data\Default\Cache\*.*"

echo Temporary files cleaned up.
