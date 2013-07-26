<!--#include file="check.asp"-->
<!--#include file=function/function_pub.asp-->
<!--#include file=function/function_db.asp-->
<!--#include file=function/function_jsp.asp-->
<%
  Dim sEp_ID,strSQL
  sEp_ID=Trim(Request("sEmp_ID"))
  strSQL="Select EP_NAME,EP_DEPNAME,EP_TEL,EP_STATION From "&Application("DBOwner")&".Grems_Employee"
  strSQL=strSQL& " Where EP_ID='"&sEp_ID&"' Order by Ep_ID"
  'Response.Write strSQL
  'Response.End
  Set Rs=server.CreateObject("ADODB.Recordset") 
  Rs.Open StrSQL,session("OraAMSCnn"),1,1
  
  Dim sEmp_Name,sEmp_DeptName,sEmp_Tel,sEmp_Station
  sEmp_Name=Trim(Rs("EP_NAME"))
  sEmp_DeptName=Trim(Rs("EP_DEPNAME"))
  sEmp_Tel=Trim(Rs("EP_TEL"))
  sEmp_Station=Trim(Rs("EP_STATION"))
  'Response.Write sEmp_Name&sEmp_DeptName&sEmp_Tel&sEmp_Station
  'Response.End
  Rs.Close 
  Set Rs=Nothing
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<title>用户资料修改</title>
<style>
TABLE
{
    FONT-SIZE: 12px;
    WIDTH: 100%;
    BORDER-COLLAPSE: collapse
}
select
{
	BORDER:1px solid #3c3;
	color:white;
	background-color:#393
}
INPUT
{
	BORDER:1px solid #3c3;
	color:black;
}
</style>
<SCRIPT LANGUAGE=javascript type=text/javascript>
<!--
	function ufModifyUser(){
		var sEp_ID=frmModify.txt_ID.value
		var sEp_NAME=frmModify.txt_NAME.value
		var sEp_DEPT=frmModify.txt_DEP.value
		var sEp_TEL=frmModify.txt_TEL.value
		var sEp_GNP=frmModify.sel_GNP.value
		var strSubmit="UserModifySave.asp?txtID="+sEp_ID+"&txtName="+sEp_NAME+"&txtDEPT="+sEp_DEPT+"&txtTEL="+sEp_TEL+"&selGNP="+sEp_GNP
		//alert(strSubmit)
		document.all.ifrSave.src=strSubmit
	}
//-->
</SCRIPT>

</head>
<body onload="frmModify.txt_NAME.focus() " language="javascript">
<center>
	<table border='0' width='100%' ><tr>
	<form action='' method=post name=frmModify id=frmModify>
		<td width='33%' colspan='2'>
		<fieldset id='fs_sysgroup' name='fs_sysgroup'>
		<legend><img SRC='../images/collection.gif' WIDTH='16'> 修改用户资料</legend>
		<table border='1' width='100%' bgcolor='#339933' bordercolorlight='#444444' bordercolordark='#339933' cellspacing=2 cellpadding=2>
			<tr><td width='100%'>
		    <table border='1' width='100%' bgcolor='#D8D0C8' bordercolorlight='#fffff' bordercolordark='#fffff'>
				<tr><td width='40%'align=right>登录用户帐号&nbsp;</td><td>&nbsp;<input style="background:#c0c0c0" type='text' readonly id='txt_ID' name='txt_ID' maxlength=7 size=16 value="<%=sEp_ID%>"></td></tr>
				<tr><td width='40%'align=right>用户姓名&nbsp;</td><td>&nbsp;<input type='text' id='txt_NAME' name='txt_NAME' maxlength=8 size=16 value="<%=sEmp_Name%>"></td>
				<tr><td width='40%'align=right>所在部门&nbsp;</td><td>&nbsp;<input type='text' id='txt_DEP' name='txt_DEP' maxlength=30 size=16 value="<%=sEmp_DeptName%>"></td>
				<tr><td width='40%'align=right>联系电话/地址&nbsp;</td><td>&nbsp;<input type='text' id='txt_TEL' name='txt_TEL' maxlength=30 size=16 value="<%=sEmp_Tel%>"></td>
   				<tr><td width='40%'align=right>所属电站&nbsp;</td><td>&nbsp;<select id='sel_GNP' name='sel_GNP'>
   																				<option value='0' <%if sEmp_Station="0" then Response.Write "selected" end if%>>&nbsp;</option>
   																				<option value='D' <%if sEmp_Station="D" then Response.Write "selected" end if%>>&nbsp;一核&nbsp;&nbsp;</option>
   																				<option value='L' <%if sEmp_Station="L" then Response.Write "selected" end if%>>&nbsp;二核&nbsp;&nbsp;</option>
   																				<option value='A' <%if sEmp_Station="A" then Response.Write "selected" end if%>>&nbsp;一/二核&nbsp;&nbsp;</option>
   																				</select></td>
			</td></tr></table>
		</td>
		<tr><td align=center>
			<input type=button id=btnMod name='btnMod' value='修改 >>' onclick='return ufModifyUser()' language="javascript" style='CURSOR: hand;border:1px solid white;background-color:#393;color:white;font-size:13px;height:20px;font-weight:bold'>&nbsp;&nbsp;
			<input type=reset id=btnReset name=btnReset value='取消 >>' onclick="txt_NAME.focus()" style='CURSOR: hand;border:1px solid white;background-color:#393;color:white;font-size:13px;height:20px;font-weight:bold'>&nbsp;&nbsp;
			<input type=button id=btnReturn name=btnReturn value='返回 >>' onclick="return window.history.go( -1)" style='CURSOR: hand;border:1px solid white;background-color:#393;color:white;font-size:13px;height:20px;font-weight:bold'>
			</td></tr>
			</td>
     <iframe id=ifrSave name=ifrSave src="" style="display:none"  width=500></iframe>
   </form></tr></table>
</center>
</body>
</html>