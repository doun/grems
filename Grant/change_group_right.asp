<%@ Language=VBScript %>

<HTML>
<head>
<%session("id")="D03"%>
<!--#include file=../../login/check_valid.asp-->

	<META http-equiv=Content-Type content="text/html; charset=gb2312">
	<link rel="stylesheet" type="text/css" href="../include/ams.css">
</head>
<!--#include file=../function/function_pub.asp-->
<!--#include file=../function/function_db.asp-->
<BODY>

<%
dim rightStr
rightStr=""
	For Each x In Request.Form 

	'Response.Write "Request.Form( "&x&" ) = "& Request.Form(x) &"<br>"
	if asc(mid(x,2,1))<=asc("9") and asc(mid(x,2,1)) >=asc("0") and asc(mid(x,1,1))<=asc("Z") and asc(mid(x,1,1))>=asc("A") then
			rightStr=rightStr&"*"&X
    end if
	Next
	if request("group_ID")="" then
		 message "����","ҳ���ʱ�������µ�¼��",0
		 call gotoPage("HOMEPAGE")
	else
		'Response.Write mid(rightStr,2)
		StrSQL="update ams.Hwork_group set WG_right='"&mid(rightStr,2)&"' where WG_ID='"&request("group_ID") &"'"
		'Response.Write strSQL
		returnStr=connect_db(strSQL) 
		if returnStr<>"0" and returnStr<>"���ݿ��޼�¼!" then 
		   message "���ݿ����",cstr(returnStr),0
		else 
		  message "��ϲ��","�Ѿ��ɹ��޸ģ�",0
		end if
    end if
 %>
<SCRIPT LANGUAGE=javascript>
<!--
window.history.back(-1)

//-->
</SCRIPT>

</BODY>

</HTML>
