@echo off
rem Download the pinned DITA-OT release and install this repository's plugins.
setlocal
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\setup.ps1" %*
exit /b %ERRORLEVEL%
