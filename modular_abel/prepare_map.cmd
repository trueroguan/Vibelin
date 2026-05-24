@echo off
pushd "%~dp0\.." || exit /b 1
call tools\bootstrap\javascript.bat modular_abel\tools\prepare_dun_world_map.ts
set "exitCode=%errorlevel%"
popd
exit /b %exitCode%
