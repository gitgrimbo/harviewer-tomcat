REM The CATALINA_HOME env var is a pre-requisite for this script
REM It must be set in your shell/terminal. E.g.
REM   set CATALINA_HOME=D:\dev\tomcat\7.0.69

REM Override QuercusServletImpl
set SERVLET_API_JAR=%CATALINA_HOME%\lib\servlet-api.jar
set QUERCUS_JAR=..\..\webapps\ROOT\WEB-INF\lib\quercus.jar
set OUTPUT_DIR=..\..\webapps\ROOT\WEB-INF\classes

REM Compile the class directly into the WEB-INF/classes folder of the webapp.
javac -classpath .;%QUERCUS_JAR%;%SERVLET_API_JAR% -d %OUTPUT_DIR% com\caucho\quercus\servlet\QuercusServletImpl.java