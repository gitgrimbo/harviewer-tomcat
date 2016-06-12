set CATALINA_HOME=PATH_TO_TOMCAT

REM Override QuercusServletImpl
set SERVLET_API_JAR=%CATALINA_HOME%\lib\servlet-api.jar
set QUERCUS_JAR=..\webapps\ROOT\WEB-INF\lib\quercus.jar
set OUTPUT_DIR=..\webapps\ROOT\WEB-INF\classes

REM Compile the class directly into the WEB-INF/classes folder of the webapp.
javac -classpath .;%QUERCUS_JAR%;%SERVLET_API_JAR% -d %OUTPUT_DIR% com\caucho\quercus\servlet\QuercusServletImpl.java