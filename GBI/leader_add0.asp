<!--#include file="function.asp"-->
<title>修改领导批示</title>
<body bgcolor=#aaddff leftMargin=0 topMargin=0 >
<%
call checksession()


id=trim(Request.Form("id"))
remark=trim(Request.Form("remark"))
	if id="" then
		str="提示：参数传递出错 "
		call gopage(str,0)
	end if
	if remark="" then
		str="提示：领导批示不能为空 "
		call gopage(str,0)
	end if
	
	sql="update "&Application("DBOwner")&".GBI_DOCUMENT set ITEM_DEPT_REMARK='"&remark&"' where ITEM_ID='"&id&"'" 
	
	
	call conn_open(sql)

	str="提示：领导批示修改成功 "
	call gopage1(str,"item_info.asp?id="&id&"")
%>