@echo off
chcp 65001 > nul
setlocal EnableDelayedExpansion

:: Path to present folder and check update
cd /d "%~dp0"
call service_status.bat zapret
call check_updates.bat soft
echo:

:: Set path to bin
set "BIN=%~dp0bin\"

:: Folder with strategys
set "STRATEGY_DIR=%~dp0strategys"

echo ==========================
echo [ZAPRET STRATEGY SELECTOR] 
echo ==========================

:: Scan all txt's
set COUNT=0
for %%F in ("%STRATEGY_DIR%\*.txt") do (
    set /a COUNT+=1
    set "STRAT_!COUNT!=%%~nxF"
    echo  !COUNT!: %%~nxF
)

:: Ask user to select
set /p SELECT=Select number at strategy:

:: Checking for select
if not defined STRAT_%SELECT% (
    echo Wrong select. Exit...
    exit /b
)

set "SELECTED_FILE=!STRAT_%SELECT%!"
set "STRATEGY_PATH=%STRATEGY_DIR%\!SELECTED_FILE!"

echo.
echo Start strategy: !SELECTED_FILE!
echo ==============================

:: Read lines from the strategy and assemble them into a single line
set "ARGS="
for /f "usebackq tokens=* delims=" %%L in ("%STRATEGY_PATH%") do (
    set "LINE=%%L"
    :: Substitute %BIN% for the real path with double quotes
    set "LINE=!LINE:%%BIN%%=%BIN%!"
    set "ARGS=!ARGS! !LINE!"
)

:: Degub for check it starts
echo [DEBUG] It starts!
echo "%BIN%winws.exe" !ARGS!
echo.
pause

:: Start winws with selected strategy
start "zapret: !SELECTED_FILE!" /min "%BIN%winws.exe" !ARGS! 

