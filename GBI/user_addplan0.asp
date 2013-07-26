<!--#include file="function.asp"-->
<title>修改项目进展</title>
<body bgcolor=#aaddff leftMargin=0 topMargin=0 >
<%
call checksession()


id=trim(Request.Form("id"))
plan=trim(Request.Form("plan"))
	if id="" then
		str="提示：参数传递出错 "
		call gopage(str,0)
	end if
	if plan="" then
		str="提示：项目进展不能为空 "
		call gopage(str,0)
	end if
	plan=plan&vbcrlf
	plan=plan&"("&now()&")"
	plan=plan&"@@"
	sql="update "&Application("DBOwner")&".GBI_DOCUMENT set ITEM_APPLY_PLAN=ITEM_APPLY_PLAN || '"&plan&"' where ITEM_ID='"&id&"'" 
	
	
	call conn_open(sql)

	str="提示：项目进展修改成功 "
	call gopage1(str,"item_info.asp?id="&id&"")
%>