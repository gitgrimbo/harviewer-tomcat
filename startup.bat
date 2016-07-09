@echo off

pushd .

REM The CATALINA_HOME env var is a pre-requisite for this script
REM It must be set in your shell/terminal. E.g.
REM   set CATALINA_HOME=D:\dev\tomcat\7.0.69

if exist "%CATALINA_HOME%\bin\catalina.bat" goto okHome
echo The CATALINA_HOME environment variable is not defined correctly
echo This environment variable is needed to run this program
goto end

:okHome

REM Need the . because catalina.bat doesn't like properties ending in \",
REM e.g. -Dcatalina.base="PATH_TO_HARVIEWER\tomcat\"
set CATALINA_BASE=%~dp0.

cd "%CATALINA_HOME%\bin"

set TITLE=HAR Viewer Tomcat

call startup.bat %TITLE%

:end

popd
