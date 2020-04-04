@echo off

CD %~dp0

set verb=/verbosity:minimal

reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && set OS=32BIT || set OS=64BIT

if %OS%==32BIT echo This is a 32bit operating system
if %OS%==64BIT echo This is a 64bit operating system

if %OS%==64BIT (set msbuild=C:\Windows\Microsoft.Net\Framework64\v4.0.30319\MSBuild.exe) ELSE (set msbuild=C:\Windows\Microsoft.Net\Framework\v4.0.30319\MSBuild.exe)

set t_20=Configuration=Release;TargetFrameworkVersion=v2.0
set t_40=Configuration=Release;TargetFrameworkVersion=v4.0;TargetFrameworkProfile=client
set t_45=Configuration=Release;TargetFrameworkVersion=v4.5
set t_mono_20=%t_20%;DefineConstants=MONO
set t_mono_45=%t_45%;DefineConstants=MONO

echo.
echo.
echo - BUILD WinForms...
echo.
%msbuild% ..\Source\Demo\WinForms\HtmlRenderer.Demo.WinForms.csproj /t:rebuild /p:%t_45%;OutputPath=..\..\..\Build\Release\Demo\WinForms %verb%

echo.
echo.
echo - BUILD Mono...
echo.

%msbuild% ..\Source\Demo\WinForms\HtmlRenderer.Demo.WinForms.csproj /t:rebuild /p:%t_mono_45%;OutputPath=..\..\..\Build\Release\Demo\Mono %verb%

echo.
echo.
echo - BUILD WPF...
echo.
%msbuild% ..\Source\Demo\WPF\HtmlRenderer.Demo.WPF.csproj /t:rebuild /p:%t_45%;OutputPath=..\..\..\Build\Release\Demo\WPF %verb%

echo.
echo - Handle outputs...
copy Release\Demo\WinForms\HtmlRendererWinFormsDemo.exe "Release\HtmlRenderer WinForms Demo.exe"
copy Release\Demo\Mono\HtmlRendererWinFormsDemo.exe "Release\HtmlRenderer Mono Demo.exe"
copy Release\Demo\WPF\HtmlRendererWpfDemo.exe "Release\HtmlRenderer WPF Demo.exe"
rmdir Release\Demo /s /q
