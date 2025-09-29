@echo off

:: --- SELF-UPDATE SECTION ---
set "myscript=%~f0"
set "updatefile=%TEMP%\update_PoE2_filter.cmd"
set "updateurl=https://raw.githubusercontent.com/pkajan/PoE2-filter/refs/heads/main/update_PoE2_filter.cmd"

curl -s -L "%updateurl%" -o "%updatefile%"

fc "%myscript%" "%updatefile%" >nul
if errorlevel 1 (
    echo New version found! Updating...
    copy /y "%updatefile%" "%myscript%" >nul
    del "%updatefile%"
    echo Restarting updated script...
	cmd /c "%myscript%"
	exit /b
) else (
    del "%updatefile%"
)
:: --- END OF SELF-UPDATE SECTION ---

setlocal enabledelayedexpansion

:: ALL IS DARKMODE

:: Create folders if they don’t exists
if not exist "%userprofile%\OneDrive\Documents\My Games\Path of Exile 2" (
    mkdir "%userprofile%\OneDrive\Documents\My Games\Path of Exile 2"
)
if not exist "%userprofile%\Documents\My Games\Path of Exile 2" (
    mkdir "%userprofile%\Documents\My Games\Path of Exile 2"
)

:: URLs NeverSink
SET "0-SOFT=https://raw.githubusercontent.com/NeverSinkDev/NeverSink-Filter-for-PoE2/refs/heads/main/(STYLE)%%20DARKMODE/NeverSink's%%20filter%%202%%20-%%200-SOFT%%20(darkmode)%%20.filter"
SET "1-REGULAR=https://raw.githubusercontent.com/NeverSinkDev/NeverSink-Filter-for-PoE2/refs/heads/main/(STYLE)%%20DARKMODE/NeverSink's%%20filter%%202%%20-%%201-REGULAR%%20(darkmode)%%20.filter"
SET "2-SEMISTRICT=https://raw.githubusercontent.com/NeverSinkDev/NeverSink-Filter-for-PoE2/refs/heads/main/(STYLE)%%20DARKMODE/NeverSink's%%20filter%%202%%20-%%202-SEMI-STRICT%%20(darkmode)%%20.filter"
SET "3-STRICT=https://raw.githubusercontent.com/NeverSinkDev/NeverSink-Filter-for-PoE2/refs/heads/main/(STYLE)%%20DARKMODE/NeverSink's%%20filter%%202%%20-%%203-STRICT%%20(darkmode)%%20.filter"
SET "4-VERYSTRICT=https://raw.githubusercontent.com/NeverSinkDev/NeverSink-Filter-for-PoE2/refs/heads/main/(STYLE)%%20DARKMODE/NeverSink's%%20filter%%202%%20-%%204-VERY-STRICT%%20(darkmode)%%20.filter"
SET "5-UBERSTRICT=https://raw.githubusercontent.com/NeverSinkDev/NeverSink-Filter-for-PoE2/refs/heads/main/(STYLE)%%20DARKMODE/NeverSink's%%20filter%%202%%20-%%205-UBER-STRICT%%20(darkmode)%%20.filter"
SET "6-UBERPLUSSTRICT=https://raw.githubusercontent.com/NeverSinkDev/NeverSink-Filter-for-PoE2/refs/heads/main/(STYLE)%%20DARKMODE/NeverSink's%%20filter%%202%%20-%%206-UBER-PLUS-STRICT%%20(darkmode)%%20.filter"

:: Default = 0-SOFT
set "choice=0-SOFT"

:: Optional: ask user for choice
echo.
echo Choose filter (default = SOFT):
echo   0 = SOFT
echo   1 = REGULAR
echo   2 = SEMI-STRICT
echo   3 = STRICT
echo   4 = VERY-STRICT
echo   5 = UBER-STRICT
echo   6 = UBER-PLUS-STRICT
set /p userchoice=Enter number [0-6, Enter = default]: 

if not "%userchoice%"=="" (
    if "%userchoice%"=="0" set "choice=0-SOFT"
    if "%userchoice%"=="1" set "choice=1-REGULAR"
    if "%userchoice%"=="2" set "choice=2-SEMISTRICT"
    if "%userchoice%"=="3" set "choice=3-STRICT"
    if "%userchoice%"=="4" set "choice=4-VERYSTRICT"
    if "%userchoice%"=="5" set "choice=5-UBERSTRICT"
    if "%userchoice%"=="6" set "choice=6-UBERPLUSSTRICT"
)

:: Resolve URL
set "selectedURL=!%choice%!"

:: File names
set "tempFile=%TEMP%\NeverSinks_Dark.filter"
set "poe2_path_onedrive=%userprofile%\OneDrive\Documents\My Games\Path of Exile 2\NeverSinks_Dark.filter"
set "poe2_path_plebs=%userprofile%\Documents\My Games\Path of Exile 2\NeverSinks_Dark.filter"

echo.
echo Downloading %choice%:
::@echo   %selectedURL%

curl -L "%selectedURL%" -o "%tempFile%"

echo.
echo Copying to OneDrive path...
copy "%tempFile%" "%poe2_path_onedrive%" /y > nul

echo.
echo Copying to local Documents path...
copy "%tempFile%" "%poe2_path_plebs%" /y > nul

del /q "%tempFile%"

echo.
echo Done! Installed filter: %choice%
pause

