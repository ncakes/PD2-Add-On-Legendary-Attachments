@echo off
set "MOD_FOLDER=AOLA"
set "MOD_LOCATION=assets\mod_overrides"
set "PAYDAY_DIR=C:\Program Files (x86)\Steam\steamapps\common\PAYDAY 2"
mklink /J "%PAYDAY_DIR%\%MOD_LOCATION%\%MOD_FOLDER%" "%~dp0%MOD_FOLDER%"
pause
