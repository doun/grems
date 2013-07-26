<!--#include file=function/function_pub.asp-->
<!--#include file=function/function_db.asp-->
<!--#include file=function/function_jsp.asp-->
<%
ep_id=trim(Request.QueryString("ep_id"))
if ep_id="" then
%>
	<script language=javascript>
	alert("参数传递出错!")
	window.history.go(-1) 
	</script>
<%
	Response.End 
else
sql="update "&Application("DBOwner")&".Grems_Employee set  ep_passwd='"&ep_id&"' where Ep_ID='"&ep_id&"'"
session("OraAMSCnn").execute(sql)
%>
	<script language=javascript>
	alert("用户密码已复位!")
	window.location.href="useradd.asp"  
	</script>	
<%
end if
%>