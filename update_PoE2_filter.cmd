@echo off

:: --- SETTINGS ---
SET "AUTOUPDATE=1"
SET "myscript=%~f0"
SET "updatefile=%TEMP%\update_PoE2_filter.cmd"
SET "updateurl=https://raw.githubusercontent.com/pkajan/PoE2-filter/refs/heads/main/update_PoE2_filter.cmd"
:: -----------------

:: Disable delayed expansion temporarily
setlocal DisableDelayedExpansion

:: --- SELF-UPDATE SECTION ---
if "%AUTOUPDATE%"=="1" (
    curl -s -L "%updateurl%" -o "%updatefile%"

    if not exist "%updatefile%" (
        echo Failed to download update file.
        goto :skipUpdate
    )

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
        echo Script up to date.
    )
) else (
    echo Auto-update disabled.
)

:skipUpdate
endlocal
:: --- END OF SELF-UPDATE SECTION ---

:: Now enable delayed expansion for rest of the script
setlocal enabledelayedexpansion

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

:: URL Greatest Filter of Them All
SET "GFoTA=https://raw.githubusercontent.com/pkajan/PoE2-filter/refs/heads/main/GFoTA.filter"

:: URLs NeverSink
SET "CHOICE0=https://raw.githubusercontent.com/NeverSinkDev/NeverSink-Filter-for-PoE2/refs/heads/main/(STYLE)%%20DARKMODE/NeverSink's%%20filter%%202%%20-%%200-SOFT%%20(darkmode)%%20.filter"
SET "CHOICE1=https://raw.githubusercontent.com/NeverSinkDev/NeverSink-Filter-for-PoE2/refs/heads/main/(STYLE)%%20DARKMODE/NeverSink's%%20filter%%202%%20-%%201-REGULAR%%20(darkmode)%%20.filter"
SET "CHOICE2=https://raw.githubusercontent.com/NeverSinkDev/NeverSink-Filter-for-PoE2/refs/heads/main/(STYLE)%%20DARKMODE/NeverSink's%%20filter%%202%%20-%%202-SEMI-STRICT%%20(darkmode)%%20.filter"
SET "CHOICE3=https://raw.githubusercontent.com/NeverSinkDev/NeverSink-Filter-for-PoE2/refs/heads/main/(STYLE)%%20DARKMODE/NeverSink's%%20filter%%202%%20-%%203-STRICT%%20(darkmode)%%20.filter"
SET "CHOICE4=https://raw.githubusercontent.com/NeverSinkDev/NeverSink-Filter-for-PoE2/refs/heads/main/(STYLE)%%20DARKMODE/NeverSink's%%20filter%%202%%20-%%204-VERY-STRICT%%20(darkmode)%%20.filter"
SET "CHOICE5=https://raw.githubusercontent.com/NeverSinkDev/NeverSink-Filter-for-PoE2/refs/heads/main/(STYLE)%%20DARKMODE/NeverSink's%%20filter%%202%%20-%%205-UBER-STRICT%%20(darkmode)%%20.filter"
SET "CHOICE6=https://raw.githubusercontent.com/NeverSinkDev/NeverSink-Filter-for-PoE2/refs/heads/main/(STYLE)%%20DARKMODE/NeverSink's%%20filter%%202%%20-%%206-UBER-PLUS-STRICT%%20(darkmode)%%20.filter"

:: Default = GFoTA
SET "choice=GFoTA"
SET "filterFileName=GFoTA"
SET "filterLabel=Greatest Filter of Them All"

:: Optional: ask user for choice
echo.
echo Choose filter (default = GFoTA):
echo.
echo   T = Greatest Filter of Them All
echo.
echo   NeverSink:
echo   0 = SOFT
echo   1 = REGULAR
echo   2 = SEMI-STRICT
echo   3 = STRICT
echo   4 = VERY-STRICT
echo   5 = UBER-STRICT
echo   6 = UBER-PLUS-STRICT
SET /p userchoice=Enter number [T, 0-6, Enter = default]: 

if not "%userchoice%"=="" (
    if "%userchoice%"=="0" (
        SET "choice=CHOICE0"
        SET "filterFileName=NeverSinks_Dark"
        SET "filterLabel=SOFT"
    )
    if "%userchoice%"=="1" (
        SET "choice=CHOICE1"
        SET "filterFileName=NeverSinks_Dark"
        SET "filterLabel=REGULAR"
    )
    if "%userchoice%"=="2" (
        SET "choice=CHOICE2"
        SET "filterFileName=NeverSinks_Dark"
        SET "filterLabel=SEMI-STRICT"
    )
    if "%userchoice%"=="3" (
        SET "choice=CHOICE3"
        SET "filterFileName=NeverSinks_Dark"
        SET "filterLabel=STRICT"
    )
    if "%userchoice%"=="4" (
        SET "choice=CHOICE4"
        SET "filterFileName=NeverSinks_Dark"
        SET "filterLabel=VERY-STRICT"
    )
    if "%userchoice%"=="5" (
        SET "choice=CHOICE5"
        SET "filterFileName=NeverSinks_Dark"
        SET "filterLabel=UBER-STRICT"
    )
    if "%userchoice%"=="6" (
        SET "choice=CHOICE6"
        SET "filterFileName=NeverSinks_Dark"
        SET "filterLabel=UBER-PLUS-STRICT"
    )
    if /I "%userchoice%"=="T" (
        SET "choice=GFoTA"
        SET "filterFileName=GFoTA"
        SET "filterLabel=Greatest Filter of Them All"
    )
)

:: Resolve URL
SET "selectedURL=!%choice%!"

:: File names
SET "tempFile=%TEMP%\%filterFileName%.filter"
SET "poe2_path_onedrive=%userprofile%\OneDrive\Documents\My Games\Path of Exile 2\%filterFileName%.filter"
SET "poe2_path_plebs=%userprofile%\Documents\My Games\Path of Exile 2\%filterFileName%.filter"

echo.
echo Downloading %choice%:
::@echo   !selectedURL!

curl -s -L "%selectedURL%" -o "%tempFile%"

:: --- VERSION INFO SECTION ---
:: Get version info from downloaded filter
set "newVersion="
for /f "tokens=2 delims=:" %%a in ('findstr /b /c:"# VERSION:" "%tempFile%"') do (
    set "newVersion=%%~a"
)
set "newVersion=%newVersion: =%"

:: Check existing file version (if exists)
set "oldVersion="

:: Prefer OneDrive path if exists, else fallback to local Documents
if exist "%poe2_path_onedrive%" (
    for /f "tokens=2 delims=:" %%a in ('findstr /b /c:"# VERSION:" "%poe2_path_onedrive%"') do (
        set "oldVersion=%%~a"
    )
) else if exist "%poe2_path_plebs%" (
    for /f "tokens=2 delims=:" %%a in ('findstr /b /c:"# VERSION:" "%poe2_path_plebs%"') do (
        set "oldVersion=%%~a"
    )
)

:: Cleanup spaces or hidden chars
set "oldVersion=%oldVersion: =%"
for /f "delims=" %%x in ("%oldVersion%") do set "oldVersion=%%~x"

echo.
:: Enable ANSI escape sequences
for /f "delims=" %%a in ('echo prompt $E^| cmd') do set "ESC=%%a"

echo.
if defined oldVersion (
    if "%oldVersion%"=="%newVersion%" (
        echo %ESC%[32mUp to date. Version %newVersion%%ESC%[0m
    ) else (
        echo %ESC%[32mUpdating: %oldVersion% ^> %newVersion%%ESC%[0m
    )
) else (
    echo %ESC%[32mInstalling new version %newVersion%%ESC%[0m
)

:: --- END OF VERSION INFO SECTION ---


echo.
echo Copying to OneDrive path...
copy "%tempFile%" "%poe2_path_onedrive%" /y > nul

echo.
echo Copying to local Documents path...
copy "%tempFile%" "%poe2_path_plebs%" /y > nul

::del /q "%tempFile%"

echo.
echo %ESC%[32mDone%ESC%[0m Installed filter: %ESC%[33m%filterLabel%%ESC%[0m
pause

