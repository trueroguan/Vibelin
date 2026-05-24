@echo off
cd /D "%~dp0"
set "TG_BOOTSTRAP_CACHE=%cd%"
if not "%~1" == "" (
	rem TGS4+: we are passed the game directory on the command line
	cd /D "%~1"
) else if exist "..\Game\B\vanderlin.dmb" (
	rem TGS3: Game/B/vanderlin.dmb exists, so build in Game/A
	cd ..\Game\A
) else (
	rem TGS3: Otherwise build in Game/B
	cd ..\Game\B
)
set CBT_BUILD_MODE=TGS
call modular_abel\build.cmd tgs
exit /b %errorlevel%
