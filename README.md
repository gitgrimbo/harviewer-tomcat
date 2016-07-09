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

**3)** Set the CATALINA_HOME environment variable.

E.g.

    set CATALINA_HOME=D:\dev\tomcat\7.0.69

**4)** Download the Quercus WAR, e.g. [quercus-4.0.39.war](http://caucho.com/download/quercus-4.0.39.war).

**5)** Extract `quercus.jar` into `WEB-INF\lib`

Extract the `quercus.jar` file from the `quercus-4.0.39.war` file and put it in the `webapps\ROOT\WEB-INF\lib` folder.

**6)** Edit `compile.bat`.

Edit `src\java\compile.bat` to point to the `servlet-api.jar` of your Tomcat installation.

**7)** `cd` into the `src\java` folder and run `compile.bat`.

The file `com\caucho\quercus\servlet\QuercusServletImpl.java` has been modified to allow for processing PHP files that lie outside of the webapp. This is necessary because the `webapps\ROOT\META-INF\context.xml` file uses aliases to refer to content outside of the webapp. By default, `QuercusServletImpl` can only load PHP files from within the webapp folder.

To compile this file, run `compile.bat` in the `src\java` folder.  This will place a new class file in the `webapps\ROOT\WEB-INF\classes` folder.

**8)** Edit `context.xml` to point to HAR Viewer webapp

Copy `src\templates\context.xml` to `webapps\ROOT\META-INF\context.xml`.

Edit `webapps\ROOT\META-INF\context.xml` to use the path to your development version of the HAR Viewer webapp.  You must use an absolute path.

E.g. replace `PATH_TO_HARVIEWER` with the path to your clone of the HAR Viewer repo, e.g. `c:\harviewer`.

````xml
    <Context
        reloadable="true"
        aliases="/webapp=PATH_TO_HARVIEWER\webapp,/webapp-build=PATH_TO_HARVIEWER\webapp-build,/selenium=PATH_TO_HARVIEWER\selenium,/tests=PATH_TO_HARVIEWER\tests,/node_modules=PATH_TO_HARVIEWER\node_modules">
    </Context>
````

**9)** Run `start.bat`.





# Using proxy for Intern code coverage

Use the `harviewer.tomcat.proxy` property when building.

    ant -Dharviewer.folder=../harviewer2 -Dharviewer.tomcat.proxy=true

This will download [UrlRewriteFilter](cdn.rawgit.com/paultuckey/urlrewritefilter/master/src/doc/manual/4.0/index.html)
and its dependencies, and use the following rule to proxy HAR Viewer webapp JS requests to the Intern proxy (which will perform code coverage).

    <rule>
        <from>/(webapp.*/.*js)$</from>
        <!-- Path to Intern proxy -->
        <to type="proxy">http://localhost:9000/$1</to>
    </rule>

You should use the appropriate `excludeInstrumentation` config for Intern so that you only instrument your JS files, and not library files (e.g. jQuery, etc).





# Using CORS

Use the `harviewer.tomcat.cors` property when building.

    ant -Dharviewer.folder=../harviewer2 -Dharviewer.tomcat.cors=true

This will download the [eBay CORS filter](https://github.com/eBay/cors-filter/) from Maven, and use the following config:

- `cors.allowed.origins=*` (allow all origins)
- `cors.support.credentials=false` (cookies are not necessary)
- `<url-pattern>*.har</url-pattern>` (only allow CORS for HAR resources)

````xml
<filter>
  <filter-name>CORS Filter</filter-name>
  <filter-class>org.ebaysf.web.cors.CORSFilter</filter-class>
  <init-param>
    <description>A comma separated list of allowed origins. Note: An '*' cannot be used for an allowed origin when using credentials.</description>
    <param-name>cors.allowed.origins</param-name>
    <param-value>*</param-value>
  </init-param>
  <init-param>
    <description>A comma separated list of HTTP verbs, using which a CORS request can be made.</description>
    <param-name>cors.allowed.methods</param-name>
    <param-value>GET,POST,HEAD,OPTIONS,PUT</param-value>
  </init-param>
  <init-param>
    <description>A comma separated list of allowed headers when making a non simple CORS request.</description>
    <param-name>cors.allowed.headers</param-name>
    <param-value>Content-Type,X-Requested-With,accept,Origin,Access-Control-Request-Method,Access-Control-Request-Headers</param-value>
  </init-param>
  <init-param>
    <description>A comma separated list non-standard response headers that will be exposed to XHR2 object.</description>
    <param-name>cors.exposed.headers</param-name>
    <param-value></param-value>
  </init-param>
  <init-param>
    <description>A flag that suggests if CORS is supported with cookies</description>
    <param-name>cors.support.credentials</param-name>
    <param-value>false</param-value>
  </init-param>
  <init-param>
    <description>A flag to control logging</description>
    <param-name>cors.logging.enabled</param-name>
    <param-value>true</param-value>
  </init-param>
  <init-param>
    <description>Indicates how long (in seconds) the results of a preflight request can be cached in a preflight result cache.</description>
    <param-name>cors.preflight.maxage</param-name>
    <param-value>10</param-value>
  </init-param>
</filter>
<filter-mapping>
  <filter-name>CORS Filter</filter-name>
  <url-pattern>*.har</url-pattern>
</filter-mapping>
````

Now URLs such as the following can be used:

- [http://harviewer:49002/webapp/?path=http://harviewer:49001/selenium/tests/hars/issue-23/images.har](#)
- [http://www.softwareishard.com/har/viewer/?path=http://harviewer:49001/selenium/tests/hars/issue-23/images.har](#)
