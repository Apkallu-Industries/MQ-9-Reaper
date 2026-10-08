@echo off
rem Build and run the offline rig against efm\bin\BNS_MQ9_EFM.dll (run efm\build.bat first).
setlocal
if "%DCS_API%"=="" set "DCS_API=D:\Eagle Dynamics\DCS World\API"
set "VSWHERE=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"
for /f "usebackq tokens=*" %%i in (`"%VSWHERE%" -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath`) do set "VSDIR=%%i"
call "%VSDIR%\VC\Auxiliary\Build\vcvars64.bat" >nul
cd /d "%~dp0"
cl /nologo /O2 /EHsc /std:c++17 /D_CRT_SECURE_NO_WARNINGS /I"%DCS_API%\include" sim_test.cpp /Fe:sim_test.exe >nul
if errorlevel 1 ( echo RIG_BUILD_FAILED & exit /b 1 )
sim_test.exe ..\bin\BNS_MQ9_EFM.dll

