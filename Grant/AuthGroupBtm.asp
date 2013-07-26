<%@ Language=VBScript %>
<%Response.Expires=0%>
<html>
<head>
<%session("id")="D03"%>
<!--#include file=../../login/check_valid.asp-->

	<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
	<link rel="stylesheet" type="text/css" href="../include/ams.css">

<!--#include file=../function/function_pub.asp-->
<!--#include file=../function/function_db.asp-->
<!--#include file=../function/function_jsp.asp-->
<title>用户</title>
<%
'------------打印数组（含有多个Cell）到表格的一行中---------------	
	sub Print_to_table(TBName)
	    Response.Write "<SCRIPT LANGUAGE=javascript>"
        for CountI=0 to Session("OraAMSRs").RecordCount-1
			Response.Write "var NewRow,iRowLen;"&vbcrlf
			Response.Write "iRowLen="&TBName&".rows.length;"&vbcrlf
			Response.Write "NewRow="&TBName&".insertRow(); "&vbcrlf
			
			'LinkStr="<a href=AuthGroupBtm.asp?WG_ID="&Session("OraAMSRs").fields("EP_ID")&" target=bottom>"&Session("OraAMSRs").fields("EP_ID")&"</a>"
			
			Response.Write "NewRow.insertCell();"&vbcrlf
		   	Response.Write TBName&".rows(iRowLen).cells(0).innerHTML ="&chr(34)&Session("OraAMSRs").fields("EP_ID")&chr(34)&";"&vbcrlf
			Response.Write "NewRow.insertCell();"&vbcrlf
		   	Response.Write TBName&".rows(iRowLen).cells(1).innerHTML ="&chr(34)&Session("OraAMSRs").fields("EP_Name")&chr(34)&";"&vbcrlf
			Response.Write "NewRow.insertCell();"&vbcrlf
		   	Response.Write TBName&".rows(iRowLen).cells(2).innerHTML ="&chr(34)&Session("OraAMSRs").fields("EP_DepName")&chr(34)&";"&vbcrlf
   			Response.Write "NewRow.insertCell();"&vbcrlf
		   	Response.Write TBName&".rows(iRowLen).cells(3).innerHTML ="&chr(34)&Session("OraAMSRs").fields("EP_CARDNO")&chr(34)&";"&vbcrlf

			session("OraAMSRs").moveNext	
	    Next
	    Response.Write "</SCRIPT>"
	  
	end sub 

sub GetUserInfo(Group_ID)
	dim returnStr
	
		StrSQL="select Ep_ID,Ep_Name,Ep_depName,EP_CARDNO from ams.HEmployee where EP_WorkGroup='"&Ucase(Group_ID)&"'"
		returnStr=connect_db(StrSQL)
		if cstr(returnStr) <> "0" and  returnStr<> "数据库无记录!" then  '判断是否oracle出错。
			message "系统错误！",cstr(returnStr),0
			exit sub
		else
			if  returnStr= "数据库无记录!"then
			    
			else
			   call Print_to_table("TB_for_Write")
			end if
		end if
end sub

%>
<script ID="clientEventHandlersJS" LANGUAGE="javascript">
<!--
var oOpener
function ModiUser_onclick(WG_ID) {
 openStr="groupUser.asp?WG_ID="+WG_ID;
 var sStyle="left=100,top=150,height=218,width=580,center=1,scroll=0,status=0,directories=0,channelmode=0"
 oOpener=FocusWin(oOpener,openStr,sStyle);
}

//-->
</script>
</head>

<body>

<table border="0" width="100%" bordercolorlight="#3399FF" bordercolordark="#99CCFF">
  <tr>
    <td width="33%" colspan="2">
    <fieldset id="fs_sysgroup" name="fs_sysgroup">
	<legend><font color="#2233FF"><img SRC="../images/maintenance/collection.gif" WIDTH="16"> 当前组用户：</font></legend>
      <table name="TB_for_Write" ID="TB_for_Write" border="1" width="100%" bordercolorlight="#800080" bordercolordark="#99CCFF" background="../images/mouse.gif">
        <tr>
          <td width="25%" bordercolorlight="#800080" bordercolordark="#99CCFF" align="center" bgcolor="#99CCFF" height="15">登录用户帐号</td>
          <td width="25%" align="center" bgcolor="#99CCFF" height="16">用户姓名</td>
          <td width="25%" align="center" bgcolor="#99CCFF" height="16">所在部门</td>
          <td width="25%" align="center" bgcolor="#99CCFF" height="16">用户信息:电话地点</td>
        </tr>
        
      </table>
    </td>
  </tr>
  <tr>
    <td width="48%" align="right">
    <img SRC="../images/button/bt_groupUser.gif" id="ModiUser" name="ModiUser" style='CURSOR: hand;' LANGUAGE="javascript" onclick="ModiUser_onclick('<%=request("WG_ID")%>')" WIDTH="76" HEIGHT="20">
  </td>
  </tr>
</table>
<%
tempStr=trim(request("WG_ID"))
if tempStr="" then tempStr="WG001"
GetUserInfo(tempStr)
%>
</body>

</html>
