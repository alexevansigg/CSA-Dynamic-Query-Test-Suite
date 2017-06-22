<%@page import="java.io.*" %>
<%@page import="java.nio.*" %>
<%@page import="java.util.*" %>
<%
  String requestedAction;
  String configPacket;
  File jsp = new File(request.getSession().getServletContext().getRealPath(request.getServletPath()));
  File plugin_home = jsp.getParentFile();
  File property_sources = new File (plugin_home.getParentFile().getParentFile() + "/propertysources");
  File[] list = property_sources.listFiles();
  File conf = new File(plugin_home + "/conf/queries.properties");
  Map<String, String> configMap = new HashMap<String, String>();
  BufferedReader br;
  String line;
  String cfilename;
  String myParam = "";

  if (request.getParameterMap().containsKey("action")){
    requestedAction = request.getParameter("action");
    if (requestedAction.equals("saveConfig")){
      configPacket = request.getParameter("config");

      if (!conf.exists()) {
        conf.createNewFile();
      }

      br = new BufferedReader(new FileReader(conf.getAbsoluteFile()));
      FileWriter fw = new FileWriter(conf.getAbsoluteFile());
      BufferedWriter bw = new BufferedWriter(fw);
      bw.write(configPacket);
      bw.close();
      out.println("Configuration Saved");
      return;
    }
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
<style>
body {
	margin: 0;
	padding-top: 70px;
	height: 100%;
}
ul, ol {
  padding: 0;
  margin: 0 0 10px 50px!important;
}
</style>
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
    		<div class="form-group">
    		   <input name="configFileName" class="form-control" placeholder="Config Name">
    		</div>
    		<button id="saveConfig" class="btn btn-default">Save</button>
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

              <div class="row-fluid">
                <div class="col-sm-4">
                  <label><%=cfilename %></label>
                </div>
                <div class="col-sm-6 form-group">
                  <input placeholder="parameters" type="text" class="form-control" value="<%=myParam %>">
                </div>
                <div class="col-sm-2">
                  <div class="btn-group">
                    <button class="test btn btn-primary btn-xs">Test</button>
                    <button class="save btn btn-sm btn-xs">Save</button>
                  </div>
                </div>
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
