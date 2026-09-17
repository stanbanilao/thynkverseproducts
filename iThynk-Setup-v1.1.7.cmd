@echo off
setlocal EnableExtensions
title iThynk v1.1.7 Setup
color 0F

echo.
echo ===============================================
echo   iThynk v1.1.7 - Thynkverse Windows Setup
echo ===============================================
echo.
echo This setup will download and install iThynk for this Windows user.
echo Keep this window open until installation is complete.
echo.

set "WORK=%TEMP%\iThynk-v1.1.7-install"
set "APP=%LOCALAPPDATA%\Thynkverse\iThynk"
set "ZIP=%WORK%\iThynk-v1.1.7-Windows.zip"

if exist "%WORK%" rmdir /s /q "%WORK%"
mkdir "%WORK%" >nul 2>&1
if errorlevel 1 goto :fail

echo [1/5] Downloading iThynk package...
curl.exe -fL --retry 3 "https://remedydebts-my.sharepoint.com/:u:/g/personal/stan_thynkverse_co_za/IQAB9gm5R6nAT5lw2QTGy3v3AXUyGskfW_TJg8m7AtN9_og?download=1" -o "%WORK%\part00"
if errorlevel 1 goto :downloadfail
curl.exe -fL --retry 3 "https://remedydebts-my.sharepoint.com/:u:/g/personal/stan_thynkverse_co_za/IQCD5H9c3lBGT7qobI3AJYjmARFLO5VfpAKLYnk-7PMWtGM?download=1" -o "%WORK%\part01"
if errorlevel 1 goto :downloadfail
curl.exe -fL --retry 3 "https://remedydebts-my.sharepoint.com/:u:/g/personal/stan_thynkverse_co_za/IQDPzsKNkKNsRJtMlzqc_y-lAdTQmeWCPjj2IqS7A3pcxIQ?download=1" -o "%WORK%\part02"
if errorlevel 1 goto :downloadfail

echo [2/5] Preparing application package...
copy /b "%WORK%\part00"+"%WORK%\part01"+"%WORK%\part02" "%ZIP%" >nul
if errorlevel 1 goto :fail

for %%F in ("%ZIP%") do set "ZIPSIZE=%%~zF"
if not defined ZIPSIZE goto :fail
if %ZIPSIZE% LSS 300000000 goto :incomplete

echo [3/5] Installing iThynk...
if exist "%APP%" rmdir /s /q "%APP%"
mkdir "%APP%" >nul 2>&1
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -Command "Expand-Archive -LiteralPath '%ZIP%' -DestinationPath '%APP%' -Force"
if errorlevel 1 goto :fail

set "EXE=%APP%\iThynk-v1.1.7.exe"
if not exist "%EXE%" goto :missing

echo [4/5] Creating shortcuts...
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -Command "$w=New-Object -ComObject WScript.Shell; $d=[Environment]::GetFolderPath('Desktop'); $s=$w.CreateShortcut((Join-Path $d 'iThynk.lnk')); $s.TargetPath='%EXE%'; $s.WorkingDirectory='%APP%'; $s.Save(); $m=[Environment]::GetFolderPath('StartMenu'); $dir=Join-Path $m 'Programs\Thynkverse'; New-Item -ItemType Directory -Force -Path $dir | Out-Null; $s2=$w.CreateShortcut((Join-Path $dir 'iThynk.lnk')); $s2.TargetPath='%EXE%'; $s2.WorkingDirectory='%APP%'; $s2.Save()"

echo [5/5] Cleaning up...
rmdir /s /q "%WORK%" >nul 2>&1

echo.
echo ===============================================
echo   iThynk v1.1.7 installed successfully.
echo ===============================================
echo.
start "" "%EXE%"
timeout /t 3 >nul
exit /b 0

:downloadfail
echo.
echo The iThynk download could not be completed.
echo Check your internet connection and run this setup again.
goto :endfail

:incomplete
echo.
echo The downloaded iThynk package was incomplete.
echo No incomplete application has been installed.
goto :endfail

:missing
echo.
echo The iThynk application file was not found after extraction.
echo Installation has been stopped.
goto :endfail

:fail
echo.
echo iThynk setup could not complete.

:endfail
echo.
pause
exit /b 1
