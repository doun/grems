
<%
'Response.End 
Response.Write "<SCRIPT LANGUAGE=javascript>"&vbcrlf
Response.Write "window.navigate('"&Request("URL")&"');"&vbcrlf 
Response.Write "</SCRIPT>"&vbcrlf
%>

