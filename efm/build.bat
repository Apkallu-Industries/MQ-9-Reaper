@echo off
rem Build BNS_MQ9_EFM.dll (x64 release) against the ED SDK headers with the MSVC toolchain found by vswhere,
rem and copy it into the mod's bin folder.
setlocal
if "%DCS_API%"=="" set "DCS_API=D:\Eagle Dynamics\DCS World\API"
if not exist "%DCS_API%\include\FM\wHumanCustomPhysicsAPI.h" ( echo NO_ED_SDK: set DCS_API to the DCS World\API folder & exit /b 3 )
set "VSWHERE=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"
for /f "usebackq tokens=*" %%i in (`"%VSWHERE%" -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath`) do set "VSDIR=%%i"
if "%VSDIR%"=="" ( echo NO_MSVC: install VS 2022 Build Tools with the C++ workload & exit /b 2 )
call "%VSDIR%\VC\Auxiliary\Build\vcvars64.bat" >nul
cd /d "%~dp0"
if not exist obj mkdir obj
if not exist bin mkdir bin
cl /nologo /O2 /EHsc /MD /W3 /std:c++17 /DWIN32 /D_WINDOWS /D_USRDLL /DNDEBUG /D_CRT_SECURE_NO_WARNINGS ^
   /I"%DCS_API%\include" /Fo"obj\\" src\*.cpp /LD /link /OUT:bin\BNS_MQ9_EFM.dll
if errorlevel 1 ( echo BUILD_FAILED & exit /b 1 )
copy /y bin\BNS_MQ9_EFM.dll "..\MQ-9 Reaper\bin\BNS_MQ9_EFM.dll" >nul
echo BUILD_OK bin\BNS_MQ9_EFM.dll

