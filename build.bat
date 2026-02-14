@echo off
setlocal

set APP_NAME=FlappyBird
set VERSION=1.0.0
set MAIN_CLASS=App

REM Clean
rmdir /s /q out 2>nul
mkdir out\classes
mkdir out\dist
mkdir out\release

REM Compile (src altında package yok)
javac -encoding UTF-8 -d out\classes src\App.java src\FlappyBird.java
if errorlevel 1 exit /b 1

REM Copy resources into classpath root
xcopy /E /I /Y resources out\classes >nul

REM Manifest
echo Main-Class: %MAIN_CLASS%> out\manifest.mf

REM Jar
jar cfm out\dist\%APP_NAME%.jar out\manifest.mf -C out\classes .
if errorlevel 1 exit /b 1

REM Test jar (optional)
java -jar out\dist\%APP_NAME%.jar

REM MSI
jpackage ^
  --type msi ^
  --name %APP_NAME% ^
  --app-version %VERSION% ^
  --input out\dist ^
  --main-jar %APP_NAME%.jar ^
  --main-class %MAIN_CLASS% ^
  --dest out\release ^
  --win-shortcut ^
  --win-menu ^
  --win-console false

echo Done. MSI is under out\release
pause
