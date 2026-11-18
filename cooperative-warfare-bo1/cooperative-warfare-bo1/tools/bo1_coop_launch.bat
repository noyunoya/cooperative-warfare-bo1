@echo off
title BO1 co-op launcher v0.1.5
echo ==== BO1 co-op launcher v0.1.5 - bo1_coop_launch.bat ====
setlocal enabledelayedexpansion
rem ---- settings (edit if your paths differ) ----
set "PLUT=%LOCALAPPDATA%\Plutonium"
set "GAME=C:\Program Files (x86)\Steam\steamapps\common\Call of Duty Black Ops"
set "MOD=mods/CoOp"
set "MAP=cuba"
set "HOSTPORT=28960"
set "NAMES=Mason Woods Bowman Carlos"
set "LOG=%~dp0launcher_log.txt"
rem -----------------------------------------------
set "BOOT=%PLUT%\bin\plutonium-bootstrapper-win32.exe"
if not exist "%BOOT%" goto :noboot
if not exist "%GAME%\BlackOps.exe" goto :nogame
echo.
echo   1 = Host  (player 1, Mason)
echo   2 = Join as player 2 (Woods)
echo   3 = Join as player 3 (Bowman)
echo   4 = Join as player 4 (Carlos)
echo   6 = Host to MAIN MENU only (no map: use this to open the co-op lobby, then join with 2-4)
echo   5 = Everything on this PC: host, then players 2..N joining automatically
echo.
set /p CH=Choose 1-5: 
if "%CH%"=="1" goto :one
if "%CH%"=="2" call :join 2
if "%CH%"=="3" call :join 3
if "%CH%"=="4" call :join 4
if "%CH%"=="5" goto :all
if "%CH%"=="6" goto :lobby
goto :finish

:lobby
set N=2
set "MAPARG="
call :host
goto :finish

:one
set /p N=How many players will play in total (2-4)? The host waits for all of them: 
call :host
goto :finish

:all
set /p N=How many players in total on this PC (2-4)? 
call :host
echo Waiting 25 s for the host to start...
timeout /t 25 /nobreak >nul
for /l %%i in (2,1,%N%) do call :joinwait %%i
goto :finish

:joinwait
call :join %1
timeout /t 15 /nobreak >nul
exit /b 0

:host
if not defined MAPARG if not "%CH%"=="6" set "MAPARG=+map %MAP%"
call :getname 1
echo [host] %NAME%
>> "%LOG%" echo %date% %time% HOST (start dir %PLUT%) "%BOOT%" t5sp "%GAME%" -lan +name %NAME% +set fs_game %MOD% +set net_port %HOSTPORT% +set sp_minplayers %N% +set party_minplayers %N% %MAPARG%
start "BO1 player 1" /D "%PLUT%" "%BOOT%" t5sp "%GAME%" -lan +name %NAME% +set fs_game %MOD% +set net_port %HOSTPORT% +set sp_minplayers %N% +set party_minplayers %N% %MAPARG%
exit /b 0

:join
set /a PORT=%HOSTPORT%+%1-1
call :getname %1
echo [join] player %1 = %NAME% on port %PORT%
>> "%LOG%" echo %date% %time% JOIN%1 (start dir %PLUT%) "%BOOT%" t5sp "%GAME%" -lan +name %NAME% +set fs_game %MOD% +set net_port %PORT% +connect 127.0.0.1:%HOSTPORT%
start "BO1 player %1" /D "%PLUT%" "%BOOT%" t5sp "%GAME%" -lan +name %NAME% +set fs_game %MOD% +set net_port %PORT% +connect 127.0.0.1:%HOSTPORT%
exit /b 0

:getname
set "I=0"
for %%n in (%NAMES%) do call :pick %%n %1
exit /b 0

:pick
set /a I+=1
if !I! EQU %2 set "NAME=%1"
exit /b 0

:finish
echo.
echo Launch commands are saved in launcher_log.txt (next to this file).
echo If a window does not open or closes at once, send me that file and Plutonium\console.log
echo from your AppData\Local folder.
pause
exit /b 0

:noboot
echo Plutonium bootstrapper not found: %BOOT%
pause
exit /b 1

:nogame
echo BO1 not found - edit the GAME= line near the top of this file and run again.
pause
exit /b 1
