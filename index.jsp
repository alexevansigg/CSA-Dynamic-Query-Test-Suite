<%--
  - Author(s): Alexander Evans
  - Date: 23/06/2017
  - @(#)
  - Description: Dynamic Query Test Suite script should allow users to quicky run configurations against csa optionsets. .
  --%>

<%@page import="java.io.*" %>
<%@page import="java.util.*" %>
<%

  String configPacket;
  String line;
  String cfilename;
  String confFilename;
  String myParam = "";
  String[] parts;
  String requestedAction = "nothing";
  String requestedConfig = "default";

  /* Build some directories */
  File jsp = new File(request.getSession().getServletContext().getRealPath(request.getServletPath()));
  File plugin_home = jsp.getParentFile();
  File conf_dir = new File(plugin_home + "/conf/");
  File property_sources = new File (plugin_home.getParentFile().getParentFile() + "/propertysources");

  /* Initialize Reader/Writers */
  FileWriter fw;
  BufferedWriter bw;
  BufferedReader br;

  /* Build an Array of the JSP Files */
  File[] list = property_sources.listFiles();

  File[] configs = conf_dir.listFiles();
  /* Load the requested action from the Post Request */
  if (request.getParameterMap().containsKey("configFileName")){
    requestedConfig = request.getParameter("configFileName");
  }

  /* Load the requested action from the Post Request */
  if (request.getParameterMap().containsKey("action")){
    requestedAction = request.getParameter("action");
  }

  /* Read the Config */
  File conf = new File(conf_dir + "/" + requestedConfig + ".properties");
  if (!conf.exists()) {
    conf.createNewFile();
  }

  Map<String, String> configMap = new HashMap<String, String>();
  if (requestedAction.equals("saveConfig")){
    configPacket = request.getParameter("config");

    br = new BufferedReader(new FileReader(conf.getAbsoluteFile()));
    fw = new FileWriter(conf.getAbsoluteFile());
    bw = new BufferedWriter(fw);
    bw.write(configPacket);
    bw.close();
    out.println("Configuration Saved");
    return;
  }

  try {

    br = new BufferedReader(new FileReader(conf.getAbsoluteFile()));
    while ((line = br.readLine()) != null) {

        String name = line.split("\\?")[0];
        String myvalue = "";
        try{
         myvalue = line.split("\\?")[1];
        } catch(Exception e){
          myvalue = "";
       }
        if (name != null && myvalue != null){
           configMap.put(name, myvalue);
        }
    }
  } catch(Exception e){
    e.printStackTrace(response.getWriter());
  }
%>
<html>
<head>
<link rel="stylesheet" type="text/css" media="all" href="/csa/static/lib/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" media="all" href="static/prettify.css">
  <link rel="stylesheet" type="text/css" media="all" href="css/dynamic-query-test-suite.css">

</head>
  <body onload="prettyPrint()">
    <nav class="navbar navbar-default navbar-fixed-top">
      <div class="container-fluid">
      <div class="navbar-header">
    	<button type="button" class="collapsed navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-2" aria-expanded="false">
    		<span class="sr-only">Toggle navigation</span>
    		<span class="icon-bar"></span>
    		<span class="icon-bar"></span>
    		<span class="icon-bar"></span>
    	</button>
    	<a href="#" class="navbar-brand">Cloud Service Automation 4.X Dynamic Property Test Suite 1.0</a>
      </div>
    	<form class="navbar-form navbar-left" role="search">

        <div class="input-group">
      	   <input id="configFileName" type="text" name="configFileName" class="form-control" placeholder="Config Name" value="<%=requestedConfig %>"/>
           <div class="input-group-btn">
             <button type="button" id="saveConfig" class="btn btn-primary">Save</button>
             <button type="button" id="deleteConfig" class="btn btn-danger">Delete</button>
             <button type="button" id="runConfig" class="btn btn-warning">Run All</button>

              <button id ="loadConfig" type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
                <span>Load</span>
                <span class="caret"></span>
              </button>

              <ul class="dropdown-menu dropdown-menu-right" role="menu">
                <%
                for (File confFile : configs) {
                  /* Only list JSP files */
                  confFilename = confFile.getName();
          
                  try{
                      %><li><a href="#"><%=confFilename.replace(".properties","") %></a></li> <%
                    }
                    catch(Exception e){
                      out.println("error");
                    }
                }
                %>
              </ul>






          </div>
        </div><!-- End of Input-group -->
    	</form>
      </div>
    </nav>

    <div class="container-fluid">
      <div class="row-fluid">
        <div id="jsps" class="col-sm-6 img-thumbnail">
          <%
          for (File cfile : list) {
            /* Only list JSP files */
            cfilename = cfile.getName();
            myParam = "";
            if (cfilename.endsWith(".jsp") && !cfilename.equals("index.jsp")){
              try{
                if(configMap.get(cfilename) != null){
                  myParam = (String) configMap.get(cfilename);
                }
              }
              catch(Exception e){
                out.println("error");
              }
              %>

              <div class="row-fluid jspRow">
                <div class="col-sm-4">
                  <label><%=cfilename %></label>
                </div>

                <div class="col-lg-6">
                  <div class="input-group">
                      <input placeholder="parameters" type="text" class="form-control" value="<%=myParam %>">
                      <span class="input-group-btn">
                        <button class="test btn btn-primary" type="button">Test</button>
                      </span>
                    </div><!-- /input-group -->
                  </div><!-- /.col-lg-6 -->




              </div>
            <%
            } // Close if jsp
          } // Close file loop
          %>
        </div>
          <div id="myResponse" class="col-sm-6 img-thumbnail" data-spy="affix" data-offset-top="70" data-offset-bottom="0">
            <pre>



[Test Response Loads Here]




            </pre>
          </div>
        </div>
      </div>
    </div>
    <script src="/csa/static/lib/jquery/jquery.min.js"></script>
    <script src="/csa/static/lib/bootstrap/js/bootstrap.min.js"></script>
    <script src="static/prettify.js"></script>
    <script src="js/dynamic-query-test-suite.js"></script>
  </body>
</html>
