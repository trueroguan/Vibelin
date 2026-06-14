@echo off
setlocal
call "%~dp0\modular_abel\build.cmd" build %*
set "exitCode=%errorlevel%"
echo.
echo ============================================================
if "%exitCode%"=="0" (
    echo  modular_abel build finished successfully.
) else (
    echo  modular_abel build FAILED with exit code %exitCode%.
    echo  Scroll up to read the compile errors.
)
echo  This window will stay open. Press any key to close it.
echo ============================================================
pause >nul
endlocal
