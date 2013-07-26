<%
set session("OraAMSCnn")=server.CreateObject("Adodb.connection") 
session("OraAMSCnn").Open Application("GREMS_ConnectionString")
set Session("OraAMSRs")=server.CreateObject("Adodb.recordset") 
%>
