<!--#include file="function.asp"-->
<title>审核项目信息</title>
<body bgcolor=#aaddff leftMargin=0 topMargin=0 >
<%
call checksession1()
userid=split(session("userinfo"),"/@")(0)
username=split(session("userinfo"),"/@")(1)
dept_id=split(session("userinfo"),"/@")(2)
leader=split(session("userinfo"),"/@")(4)
if dept_id<>"1" then
	str="提示：你不是商务科长 "
	call gopage(str,0)
end if
typeinfo=trim(Request("typeinfo"))
id=trim(Request("id"))
if typeinfo="" or id="" then
	str="提示：参数传递错误 "
	call gopage(str,0)	
end if

if typeinfo="1" or  typeinfo="2" or  typeinfo="3" then
	select case typeinfo
		case "1"
			title="退回修改"
		case "2"
			title="取消项目"
		case "3"
			title="通过审核"
	end select
	sql="update "&Application("DBOwner")&".GBI_DOCUMENT set ITEM_TYPE_ID='"&typeinfo&"' where ITEM_ID='"&id&"'" 
else
	str="提示：参数传递错误 "
	call gopage(str,0)	
end if


call conn_open(sql)
	str="提示：项目申请已 "&title&""
call gopage1(str,"item_info.asp?id="&id&"")
%>
