<!--#include file="check.asp"-->
<!--#include file=function/function_pub.asp-->
<!--#include file=function/function_db.asp-->
<!--#include file=function/function_jsp.asp-->
<%
  Dim sEp_ID,sEp_Name,sEp_Dept,sEp_Tel,sEp_GNP
  sEp_ID=Trim(Request("txtID"))
  sEp_Name=Trim(Request("txtNAME"))
  sEp_Dept=Trim(Request("txtDEPT"))
  sEp_Tel=Trim(Request("txtTEL"))
  sEp_GNP=Trim(Request("selGNP"))
  
  Dim strSQL
  strSQL="Update "&Application("DBOwner")&".Grems_Employee "
  strSQL=strSQL & " Set EP_NAME='"&sEp_Name&"',EP_DEPNAME='"&sEp_Dept&"',EP_TEL='"&sEp_Tel&"',EP_STATION='"&sEp_GNP&"' "
  strSQL=strSQL & " Where EP_ID='"&sEp_ID&"'"
  'Response.Write strSQL
  'Response.End
  Set Rs=server.CreateObject("ADODB.Recordset") 
  Rs.Open strSQL,session("OraAMSCnn")
  Set Rs=Nothing
%>
<SCRIPT LANGUAGE=javascript>
<!--
	alert("用户资料修改成功！")
	parent.window.location.href="userAdd.asp"
//-->
</SCRIPT>
