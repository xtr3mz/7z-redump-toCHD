echo off
chcp 65001
cls
echo. ******************************************************************
echo. *                           ZZZ to CHD                           *
echo. *               https://t.me/RaspberryPiEmuladores               *
echo. ******************************************************************
Timeout /t 2 >nul

set ex=gdi
set initpath=%cd%
set inppath=%cd%\in
set outpath=%cd%\out
set tmpx=%cd%\tmp
set zip=Y
set vchd=245
:config
cls
echo. ************************************************************************************************
echo.
echo. *** Default confing ***
echo.
echo. ** Input extension: (Press [1] to change) ** 
echo. ** toc, cue, nrg, gdi ** 
echo. %ex%
echo.
echo. ** Input folder:  (Press [2] to change) ** 
echo. %inppath%
echo.
echo. ** Output folder: (Press [3] to change) ** 
echo. %outpath%
echo.
echo. ** Are compressed files (.zip/.7z/.rar)? (Press [4] to change) ** 
echo. %zip%
echo.
echo. ** chdman version:  (Press [5] to change) ** 
echo. %vchd%
echo.
echo. ************************************************************************************************
echo. [Y] Continue,  [N] Exit,  [1-5] Change confing. And press ENTER
echo.

set /P conf=
if /I "%conf%"=="Y" goto :continue
if /I "%conf%"=="N" goto :exit
if "%conf%"=="1" goto :conf1
if "%conf%"=="2" goto :conf2
if "%conf%"=="3" goto :conf3
if "%conf%"=="4" goto :conf4
if "%conf%"=="5" goto :conf5
echo. *** Only [1-5] or [Y/N]  ***
Timeout /t 4 >nul
goto :config

:conf1
cls
echo.
echo. *** Write input extension (for example: gdi) and press ENTER ***
echo.
set /P ex=
goto :config

:conf2
cls
echo.
echo. *** Write input folder path (for example: C:\roms) and press ENTER ***
echo.
set /P inppath=
goto :config

:conf3
cls
echo.
echo. *** Write output folder path (for example: C:\roms\CHD output) and press ENTER ***
echo.
set /P outpath=
goto :config

:conf4
echo.
echo. *** Are the input files .zip/.7z/.rar? [Y/N] ***
echo.
set /P zip=
if /I "%zip%"=="Y" goto :config
if /I "%zip%"=="N" goto :config
echo. *** Only [Y/N] ***
Timeout /t 4 >nul
goto :conf4

:conf5
cls
echo.
echo. *** Write chdman version (for example: 196) and press ENTER ***
echo.
set /P vchd=
echo %vchd%|findstr /xr "[1-9][0-9]* 0" >nul && (
	goto :config
	) || (
	echo %vchd% is NOT a valid number
	Timeout /t 4 >nul
	goto :conf5
)
goto :config


:continue
cls
echo.
echo. *** Go Go Go!  *** 
echo.
Timeout /t 2 >nul
cls
set hour=%time:~0,2%
if "%hour:~0,1%" == " " set hour=0%hour:~1,1%
set min=%time:~3,2%
if "%min:~0,1%" == " " set min=0%min:~1,1%
set secs=%time:~6,2%
if "%secs:~0,1%" == " " set secs=0%secs:~1,1%
set logx="%initpath%/log.txt"

echo.[%DATE%-%TIME%] Initialization Log>>%logx%
echo.Default confing>>%logx%
echo.-Input extension: %ex%>>%logx%
echo.-Input folder: %inppath%>>%logx%
echo.-Output folder: %outpath%>>%logx%
echo.-Chdman version: %vchd%>>%logx%

if not exist "%outpath%" mkdir "%outpath%" 

if /I "%zip%"=="Y" (
	set tmpdir=%initpath%\tmp
	set exrom=*.zip *.7Z *.rar
	) else (
	set exrom=*.%ex%
	)

cd %inppath%
for /R %%E in (%exrom%) do (
	echo.*** Processing %%~nE ***
	echo.--Processing %%~nE>>%logx%
	echo.[%DATE%-%TIME%] Processing %%~nE>>%logx%
	if /I "%zip%"=="Y" (
		echo.Please Wait. Extracting %%E to tmp
		echo.[%DATE%-%TIME%] Extracting %%E to tmp>>%logx%
		if not exist "%tmpx%" mkdir %tmpx% 
		echo.[%DATE%-%TIME%] Init 7Z>>%logx%		
		"%initpath%\7z.exe" x "%%E" -o"%tmpx%" -y>>%logx%
		echo.[%DATE%-%TIME%] End 7Z>>%logx%		
	
		cd %tmpx%
		for /R %%Z in (*.%ex%) do (
			echo.Converting %%~nZ.%ex% to %%~nZ.chd
			echo.Create CHD -i "%tmpx%\%%~nZ.%ex%" -o "%outpath%\%%~nZ.chd" 
			echo.[%DATE%-%TIME%] Create CHD -i "%tmpx%\%%~nZ.%ex%" -o "%outpath%\%%~nZ.chd">>%logx%
			echo.[%DATE%-%TIME%] Init CHDMAN>>%logx%
			if %vchd% GEQ 146 ( "%initpath%\chdman" createcd -i "%%Z" -o "%outpath%\%%~nZ.chd" -f>>%logx% 
				) else ( "%initpath%\chdman" -createcd "%%Z" "%outpath%\%%~nZ.chd">>%logx% )
			echo.[%DATE%-%TIME%] End CHDMAN>>%logx%
		)
		echo.Cleaning temp files in %tmpx%
		echo.[%DATE%-%TIME%] Cleaning temp files in %tmpx%>>%logx%
		FOR /R /r %%Z IN (*.*) DO ( 
			echo.Delete %%Z 
			echo.[%DATE%-%TIME%] Delete: %%Z>>%logx%
			del "%%Z" /q>>%logx%
		) 		
		echo.Delete all Subfolders of %tmpx%
		echo.[%DATE%-%TIME%] Delete all Subfolders of %tmpx%>>%logx%
		IF exist "%tmpx%" rd/s/q "%tmpx%">>%logx%		
		echo.End of cleaning temp files
		echo.[%DATE%-%TIME%] End of cleaning temp files>>%logx%
	) else (
		echo.Converting %%~nE.%ex% to %%~nE.chd
		echo.Create CHD -i "%inppath%\%%~nE.%ex%" -o "%outpath%\%%~nE.chd" 
		echo.[%DATE%-%TIME%] Create CHD -i "%inppath%\%%~nE.%ex%" -o "%outpath%\%%~nE.chd">>%logx%		
		echo.[%DATE%-%TIME%] Init CHDMAN>>%logx%
		if %vchd% GEQ 146 ( "%initpath%\chdman" createcd -i "%%E" -o "%outpath%\%%~nE.chd" -f>>%logx%
			) else ( "%initpath%\chdman" -createcd "%%E" "%outpath%\%%~nE".chd>>%logx% )
		echo.[%DATE%-%TIME%] End CHDMAN>>%logx%
	)

	echo.
	echo.>>%logx%
)

if /I "%zip%"=="Y" (
	echo.Delete folder %tmpx%
	echo.[%DATE%-%TIME%]Delete folder %tmpx%>>%logx%
	IF exist "%tmpx%" rmdir /s /q  "%tmpx%">>%logx%
)

echo.[%DATE%-%TIME%] End Log>>%logx%
:exit
echo.End
echo. 
pause
