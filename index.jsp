<%@ page session = "true" %>
<%@ page import = "java.io.*,java.util.*, javax.servlet.*, org.apache.commons.io.*, java.nio.charset.Charset" %>
<%@ page import = "javax.servlet.http.*" %>
<%@ page import = "org.apache.commons.fileupload.*" %>
<%@ page import = "org.apache.commons.fileupload.disk.*" %>
<%@ page import = "org.apache.commons.fileupload.servlet.*" %>
<%@ page import = "org.apache.commons.io.output.*" %>
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="utf-8">
  <meta content="width=device-width, initial-scale=1.0" name="viewport">

  <title>Inner Page - Astgik Bootstrap Template</title>
  <meta content="" name="description">
  <meta content="" name="keywords">

  <!-- Favicons -->
  <link href="assets/img/favicon.png" rel="icon">
  <link href="assets/img/apple-touch-icon.png" rel="apple-touch-icon">

  <!-- Google Fonts -->
  <link href="https://fonts.googleapis.com/css?family=Montserrat:300,400,500,700|Open+Sans:300,300i,400,400i,700,700i" rel="stylesheet">

  <!-- Vendor CSS Files -->
  <link href="assets/vendor/aos/aos.css" rel="stylesheet">
  <link href="assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <link href="assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
  <link href="assets/vendor/glightbox/css/glightbox.min.css" rel="stylesheet">

  <!-- Template Main CSS File -->
  <link href="assets/css/style.css" rel="stylesheet">

  <!-- =======================================================
  * Template Name: Avilon - v4.7.0
  * Template URL: https://bootstrapmade.com/avilon-bootstrap-landing-page-template/
  * Author: BootstrapMade.com
  * License: https://bootstrapmade.com/license/
  ======================================================== -->
</head>

<body>

  <!-- ======= Header ======= -->
  <header id="header" class="fixed-top d-flex align-items-center ">
    <div class="container d-flex justify-content-between align-items-center">

      <div id="logo">
        <h1><a href="index.html">Astgik</a></h1>
        <!-- Uncomment below if you prefer to use an image logo -->
        <!-- <a href="index.html"><img src="assets/img/logo.png" alt=""></a> -->
      </div>

      <nav id="navbar" class="navbar">
        <ul>
          <li><a class="nav-link scrollto " href="index.html#hero">Home</a></li>
          <li><a class="nav-link scrollto" href="index.html#about">About</a></li>
          <li><a class="nav-link scrollto" href="index.html#features">Features</a></li>
          <li><a class="nav-link scrollto" href="index.html#contact">Contact</a></li>
        </ul>
        <i class="bi bi-list mobile-nav-toggle"></i>
      </nav><!-- .navbar -->
    </div>
  </header><!-- End Header -->

  <main id="main">

    <!-- ======= Breadcrumbs Section ======= -->
    <section class="breadcrumbs">
      <div class="container">

        <div class="d-flex justify-content-between align-items-center">
          <h2>Analyze Image</h2>
          <ol>
            <li><a href="index.html">Home</a></li>
            <li>Analyze Image</li>
          </ol>
        </div>

      </div>
    </section><!-- End Breadcrumbs Section -->

    <section class="inner-page">
      <div class="container">
        <%
                File file ;
                int maxFileSize = 5000 * 1024;
                int maxMemSize = 5000 * 1024;
                ServletContext context = pageContext.getServletContext();
                String filePath = "/var/lib/tomcat9/webapps/uploads/images/"; //context.getInitParameter("file-upload");
                String contentType = request.getContentType();
                String uuidStr = request.getParameter("filename");
                if ((contentType.indexOf("multipart/form-data") >= 0) && uuidStr == null) {
                   DiskFileItemFactory factory = new DiskFileItemFactory();
                   factory.setSizeThreshold(maxMemSize);
                   factory.setRepository(new File("/var/lib/tomcat9/webapps/uploads/images/"));
                   ServletFileUpload upload = new ServletFileUpload(factory);
                   upload.setSizeMax( maxFileSize );

                   try {
                      List fileItems = upload.parseRequest(request);
                      Iterator i = fileItems.iterator();
                      while ( i.hasNext () ) {
                         FileItem fi = (FileItem)i.next();
                         if ( !fi.isFormField () ) {
                            String fieldName = fi.getFieldName();
                            String fileName = fi.getName();
                            boolean isInMemory = fi.isInMemory();
                            long sizeInBytes = fi.getSize();
             	              UUID uuid=UUID.randomUUID(); //Generates random UUID
                            file = new File(filePath + uuid + ".jpg");
                            fi.write( file ) ;

                             Process p = new ProcessBuilder("python3", "/var/lib/tomcat9/webapps/uploads/test.py", "--arg1", "" + uuid).start();
                     	       String stderr = IOUtils.toString(p.getErrorStream(), Charset.defaultCharset());
                     	       String stdout = IOUtils.toString(p.getInputStream(), Charset.defaultCharset());
                     	       stdout = stdout.replace(' ', '|');

                     	       String strResult = "";
                     	       if(stdout.contains("False|False||True")){
             			               strResult = "Breast X-Ray";
             	               }
             	               if(stdout.contains("True|False|False")){
             			               strResult = "Brain X-Ray";
             	               }
             	               if(stdout.contains("False||True|False")){
             			               strResult = "Chest X-Ray";
             	               }

                             Process pweb3 = new ProcessBuilder("python3", "/var/lib/tomcat9/webapps/uploads/address.py").start();
                     	       String stderrweb3 = IOUtils.toString(pweb3.getErrorStream(), Charset.defaultCharset());
                     	       String stdoutweb3 = IOUtils.toString(pweb3.getInputStream(), Charset.defaultCharset());

             	       %>
             	       <form method="post" action="index.jsp" >
                       Payment Details: SEND 10 <a href="https://etherscan.io/token/0x422dfc70f2e589fbb83fe62163c48dd9fc2486c4" >$ASTGIK</a> TO
                       <%=stdoutweb3.substring(stdoutweb3.indexOf("Address") + 9, stdoutweb3.length()).trim()%>
                       <%
                          session.setAttribute(uuid+"", stdoutweb3.substring(stdoutweb3.indexOf("Address") + 9, stdoutweb3.length()).trim());
                       %>
                       <BR><BR>
             		       <input type=hidden name=filename id=filename value=<%=uuid+""%> />
                       <div class="w-50 p-3" style="background-color: #eee;">
                       <div class="input-group">
                         <select name="imgType" id="imgType" class="form-select" >
                         	<option >select</option>
                         	<option value="Pneumonia" <%if(strResult.equals("Chest X-Ray")){%>selected<% }%> >Chest</option>
                         	<option value="BrainTumor" <%if(strResult.equals("Brain X-Ray")){%>selected<% }%> >Brain</option>
                         	<option value="BreastCancer" <%if(strResult.equals("Breast X-Ray")){%>selected<% }%> >Breast</option>
                         </select>
                         <span class="input-group-btn">
                          <input type="submit" value="NEXT" class="btn btn-info">
                         </span>
                       </div>
                       </div>
             		     </form>
                     <BR>
                     <BR>
             	       <%
                         }
                      }
                   } catch(Exception ex) {
                      System.out.println(ex);
             	        %><%=ex + ""%><%
                   }
                } else if(uuidStr !=null){
                            String acct_address = (String)session.getAttribute(uuidStr);

                            Process pweb3 = new ProcessBuilder("python3", "/var/lib/tomcat9/webapps/uploads/balance.py", "--arg1", acct_address).start();
                            String stderrweb3 = IOUtils.toString(pweb3.getErrorStream(), Charset.defaultCharset());
                            String stdoutweb3 = IOUtils.toString(pweb3.getInputStream(), Charset.defaultCharset());

                            Process p = new ProcessBuilder("python3", "/var/lib/tomcat9/webapps/uploads/test2.py", request.getParameter("imgType"), uuidStr).start();
                            String stderr = IOUtils.toString(p.getErrorStream(), Charset.defaultCharset());
                            String stdout = IOUtils.toString(p.getInputStream(), Charset.defaultCharset());
                            stdout = stdout.replace(' ', '|');

                            String strResult = "";
                            %>
                            Account: <%=acct_address%>
                            BALANCE : <%=stdoutweb3.substring(stdoutweb3.indexOf("Balance") + 8, stdoutweb3.length()).trim()%>
                            <BR>
                            <%if(Integer.parseInt(stdoutweb3.substring(stdoutweb3.indexOf("Balance") + 8, stdoutweb3.length()).trim())>=10){%>
                               Thank you
                            <%}else{%>
                               Not enough funds, Please consider donating ethereum to astgik.eth.
                            <%}%>
                            <BR><BR>
                            <%
                            if(stdout.contains("True")){
                                    %>
                                    <div class="alert alert-danger" role="alert">
                                      Not having or showing good Information.
                                    </div>
                                    <%
                            }
                            if(stdout.contains("False")){
                                    %>
                                    <div class="alert alert-success" role="alert">
                                      Having or showing good Information.
                                    </div>
                                    <%
                            }
                } else {
                   out.println("<p>No file uploaded</p>");
                }
        %>
      </div>
    </section>

  </main><!-- End #main -->

  <!-- ======= Footer ======= -->
  <footer id="footer">
    <div class="container">
      <div class="row">
        <div class="col-lg-6 text-lg-start text-center">
          <div class="copyright">
            &copy; Copyright <strong>Astgik</strong>. All Rights Reserved
          </div>
          <div class="credits">
            <!--
            All the links in the footer should remain intact.
            You can delete the links only if you purchased the pro version.
            Licensing information: https://bootstrapmade.com/license/
            Purchase the pro version with working PHP/AJAX contact form: https://bootstrapmade.com/buy/?theme=Avilon
          -->
            Designed by <a href="https://bootstrapmade.com/">BootstrapMade</a>
          </div>
        </div>
        <div class="col-lg-6">
          <nav class="footer-links text-lg-right text-center pt-2 pt-lg-0">
            <a href="#intro" class="scrollto">Home</a>
            <a href="#about" class="scrollto">About</a>
            <a href="#">Privacy Policy</a>
            <a href="#">Terms of Use</a>
          </nav>
        </div>
      </div>
    </div>
  </footer><!-- End  Footer -->

  <a href="#" class="back-to-top d-flex align-items-center justify-content-center"><i class="bi bi-chevron-up"></i></a>

  <!-- Vendor JS Files -->
  <script src="assets/vendor/aos/aos.js"></script>
  <script src="assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
  <script src="assets/vendor/glightbox/js/glightbox.min.js"></script>
  <script src="assets/vendor/php-email-form/validate.js"></script>

  <!-- Template Main JS File -->
  <script src="assets/js/main.js"></script>
  <script async src="https://www.googletagmanager.com/gtag/js?id=G-VE5C3KKF27"></script>
  <script>
    window.dataLayer = window.dataLayer || [];
    function gtag(){dataLayer.push(arguments);}
    gtag('js', new Date());

    gtag('config', 'G-VE5C3KKF27');
  </script>
</body>

</html>
