@echo off
title BO1 Operation 40 co-op v0.1.0
echo ==== BO1 Operation 40 co-op v0.1.0 - install_cuba_coop.bat ====
setlocal
cd /d "%~dp0"
echo Drag your INSTALLED co-op mod folder (the one that contains mod.ff and mod.json) onto this window, then press Enter.
set /p DEST=Mod folder: 
set DEST=%DEST:"=%
if not exist "%DEST%\mod.ff" (
  echo mod.ff not found in "%DEST%" - wrong folder.
  pause & exit /b 1
)
if not exist "%DEST%\mod.iwd.orig" copy /y "%DEST%\mod.iwd" "%DEST%\mod.iwd.orig" >nul
copy /y "Co-Op\mod.iwd" "%DEST%\mod.iwd" >nul
echo Installed. Your old mod.iwd is saved as mod.iwd.orig (copy it back to undo).
echo Start Operation 40 with the mod loaded, join with a second player, and look for CUBACOOP lines on screen.
pause
