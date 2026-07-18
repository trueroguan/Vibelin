@echo off
pushd "%~dp0\..\.." || exit /b 1
call modular_abel\prepare_map.cmd
if not %errorlevel% == 0 (
    set "exitCode=%errorlevel%"
    popd
    exit /b %exitCode%
)
call tools\bootstrap\javascript.bat modular_abel\tools\runtime_config.ts
set "exitCode=%errorlevel%"
popd
exit /b %exitCode%
