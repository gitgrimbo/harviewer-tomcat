This repo provides a simple way to run [HAR Viewer](https://github.com/janodvarko/harviewer)
on Tomcat.  This is especially useful during development of HAR Viewer for
environments that don't have (or don't want) a PHP installation.  The
[Quercus](http://quercus.caucho.com/) PHP engine is used.





# Auto Setup

Requires [Ant](http://ant.apache.org/) to be installed.

**1)** Clone this repo.

**2)** Download and install [Tomcat 7](http://tomcat.apache.org/download-70.cgi) (version 7 has been tested, the config files in the conf folder are for Tomcat 7).

**3)** Set the CATALINA_HOME environment variable.

E.g.

    set CATALINA_HOME=D:\dev\tomcat\7.0.69

**4)** Run ant, passing in the location of the harviewer repo and the location of Tomcat.

E.g.:

    ant -Dharviewer.folder=../harviewer2

The `harviewer.folder` property can be a relative path - this path will be made absolute as required by the Ant script.

The ant script will download the Quercus WAR and setup a webapp for harviewer.

**5)** Run `start.bat`.





# Manual Setup

**1)** Clone this repo.

**2)** Download and install [Tomcat 7](http://tomcat.apache.org/download-70.cgi) (version 7 has been tested, the config files in the conf folder are for Tomcat 7).

**3)** Download the Quercus WAR, e.g. [quercus-4.0.39.war](http://caucho.com/download/quercus-4.0.39.war).

**4)** Extract `quercus.jar` into `WEB-INF/lib`

Extract the `quercus.jar` file from the `quercus-4.0.39.war` file and put it in the `webapps\ROOT\WEB-INF\lib` folder.

**5)** Edit `compile.bat`.

Edit `src\compile.bat` to point to the `servlet-api.jar` of your Tomcat installation.

**6)** `cd` into the `src` folder and run `compile.bat`.

The file `com\caucho\quercus\servlet\QuercusServletImpl.java` has been modified to allow for processing PHP files that lie outside of the webapp. This is necessary because the `webapps\ROOT\META-INF\context.xml` file uses aliases to refer to content outside of the webapp. By default, `QuercusServletImpl` can only load PHP files from within the webapp folder.

To compile this file, run `compile.bat` in the `src` folder.  This will place a new class file in the `webapps\ROOT\WEB-INF\classes` folder.

**7)** Edit `context.xml` to point to HAR Viewer webapp

Edit `webapps\ROOT\META-INF\context.xml` to use the path to your development version of the HAR Viewer webapp.  You must use an absolute path.

E.g. replace `PATH_TO_HARVIEWER` with the path to your clone of the HAR Viewer repo, e.g. `c:\harviewer`.

````xml
    <Context
        reloadable="true"
        aliases="/webapp=PATH_TO_HARVIEWER\webapp,/webapp-build=PATH_TO_HARVIEWER\webapp-build,/selenium=PATH_TO_HARVIEWER\selenium">
    </Context>
````

**8)** Set the CATALINA_HOME environment variable.

E.g.

    set CATALINA_HOME=D:\dev\tomcat\7.0.69

**9)** Run `start.bat`.
