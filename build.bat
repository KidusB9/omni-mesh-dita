@echo off
rem Publish every deliverable (HTML5 site, user PDF, technical PDF) in one command.
rem Usage: build.bat [all|site|pdf-user|pdf-technical]
setlocal
set "TARGET=%~1"
if "%TARGET%"=="" set "TARGET=all"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\build.ps1" -Deliverable %TARGET%
exit /b %ERRORLEVEL%
