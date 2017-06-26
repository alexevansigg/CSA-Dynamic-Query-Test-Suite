
#  CSA Dynamic Query Suite

---
####  Current Version 0.01
----

This plugin allows a developer to run quick tests against stored configurations for dynamic query JSPs.
The plugin itself will list all JSP scripts which are stored in the property sources folder.

![CSA Dynamic Query Interface](screenshots/Screen Shot 2017-06-26 at 15.29.12.png("CSA Example Interface")



The following features are exposed in this plugin with the aim of enhancing the CSA Operations experience
- __Inline Execute Dynamic Queries__
- __Traffic Light Button Responses__
- __Prettified XML Response__

1. Create the folder custom-content (if it doesnt allready exist) in directory **<CSAHOME>/jboss-as/standalone/csa.war**
2. Extract the Plugin contents into the custom-content folder, observe the correct folder structure in the custom-content folder as below:

 File Contents / Folder Structure

 + CSA-Dynamic-Query-Test-Suite/conf/queries.properties
 + CSA-Dynamic-Query-Test-Suite/js/dynamic-query-test-suite.js
 + CSA-Dynamic-Query-Test-Suite/static/prettify.css
 + CSA-Dynamic-Query-Test-Suite/static/prettify.css
 + CSA-Dynamic-Query-Test-Suite/index.jsp
 + CSA-Dynamic-Query-Test-Suite/README.md

3. Add the corresponding entry to the csa.war/dashboard/config.json depending on the installed csa version.
  (inside main.tiles array or in sub panel see **CSA Configuration guide** if unsure how to manipulate this file)

  **CSA 4.6+**
  ```JSON
  	{
  		"id": "CSA-Dynamic-Query-Test-Suite",
  		"name": "CSA-Dynamic-Query-Test-Suite",
  		"description": "CSA-Dynamic-Query-Test-Suite_description",
  		"enabled": true,
  		"style": "custom-tile-header",
  		"type": "iframe",
  		"url": "/csa/custom-content/CSA-Dynamic-Query-Test-Suite/",
  		"helptopic": "console_help",
  		"roles": ["CSA_ADMIN"]
  	}
  ```

4. Open the file **csa.war/dashboard/messages/common/messages.properties** and navigate to the section entitled:
  ```
  # Page titles and descriptions, used for the dashboard tiles and for navigation views
  ```
  Add the following entries

  ```JSON
  CSA-Dynamic-Query-Test-Suite=Dynamic Query Test Suite
  CSA-Dynamic-Query-Test-Suite_description=This interface allows quick tests of dynamic queries
  ```

5. As the plugin is installed to a custom directory in the csa webapp it's a good idea to add an intercept-url directive to the ```applicationContext-security.xml```. Adding such a rule will check the user accessing the url is allready authenticated with CSA, if its not an authenticated session it will redirect them to the login page.
The plugin itself is allready trying to check the users roles via the script defined in the previous step (user.jsp). But this expects an authenticated user. Adding the below mentioned directive will prevent exceptions being thrown and errors written in the csa.log.
  ```xml
  <intercept-url pattern="/custom-content/**" access="isAuthenticated()"/>
  ```

6. In the same ```applicationContext-security.xml``` change the permissions to the property source folder so it can be accessed by the dynamic-query-test-suite.
    ```xml
    <intercept-url pattern="/propertysources/**"  access="isAuthenticated()"/>
    ```
