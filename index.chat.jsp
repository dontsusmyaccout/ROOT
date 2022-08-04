<%@ page session = "true" import = "org.apache.commons.io.output.*,org.apache.commons.fileupload.servlet.*,org.apache.commons.fileupload.disk.*,org.apache.commons.fileupload.*,javax.servlet.http.*,java.io.*,java.util.*, javax.servlet.*, org.apache.commons.io.*, java.nio.charset.Charset" %><%
Process p = new ProcessBuilder("python3", "/var/lib/tomcat9/webapps/uploads/testopenai.py", "--arg1", "" + request.getParameter("aichatbot")).start();
String stderr = IOUtils.toString(p.getErrorStream(), Charset.defaultCharset());
String stdout = IOUtils.toString(p.getInputStream(), Charset.defaultCharset());

stdout = stdout.substring(stdout.indexOf("text\": \"") + 9, stdout.length());
stdout = stdout.substring(0, stdout.indexOf("\"")).trim();
if(stdout.indexOf("Assistant:")>0)stdout = stdout.substring(stdout.indexOf("Assistant:") + 10, stdout.length());
if(stdout.indexOf("AI:")>0)stdout = stdout.substring(stdout.indexOf("AI:") + 3, stdout.length());
stdout = stdout.replaceAll("\n", "").replaceAll("\r", "");

%><%=stdout%>
