@REM ----------------------------------------------------------------------------
@REM Maven Wrapper Startup Script
@REM ----------------------------------------------------------------------------
@echo off
setlocal

set "MAVEN_PROJECTBASEDIR=%~dp0"
set "MVNW_VERBOSE=false"

if not defined MVNW_REPOURL (
    set "MVNW_REPOURL=https://mirrors.aliyun.com/apache/maven/wrapper/maven-wrapper/3.2.0/maven-wrapper-3.2.0.jar"
)

set "MVNW_MAVEN_HOME=%USERPROFILE%\.m2\wrapper\dists\apache-maven-3.9.6-bin"
set "MAVEN_OPTS=-Xmx1024m"

if not exist "%MVNW_MAVEN_HOME%\bin\mvn.cmd" (
    echo Downloading Maven...
    if not exist "%USERPROFILE%\.m2\wrapper" mkdir "%USERPROFILE%\.m2\wrapper"
    powershell -Command "Invoke-WebRequest -Uri '%MVNW_REPOURL%' -OutFile '%USERPROFILE%\.m2\wrapper\maven-wrapper.jar'"
    java -jar "%USERPROFILE%\.m2\wrapper\maven-wrapper.jar" -Dmaven.repo.local="%USERPROFILE%\.m2\repository"
)

set "M2_HOME=%MVNW_MAVEN_HOME%"
set "PATH=%MVNW_MAVEN_HOME%\bin;%PATH%"

mvn %*
