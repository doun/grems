<!--#include file="function.asp"-->
<title>审核项目信息</title>
<body bgcolor=#aaddff leftMargin=0 topMargin=0 >
<%
call checksession1()
userid=split(session("userinfo"),"/@")(0)
username=split(session("userinfo"),"/@")(1)
dept_id=split(session("userinfo"),"/@")(2)
leader=split(session("userinfo"),"/@")(4)
if dept_id<>"2" then
	str="提示：你不是合同处长 "
	call gopage(str,0)
end if
typeinfo=trim(Request("typeinfo"))
id=trim(Request("id"))
if typeinfo="" or id="" then
	str="提示：参数传递错误 "
	call gopage(str,0)	
end if

if typeinfo="4" or  typeinfo="5" or  typeinfo="6" then
	select case typeinfo
		case "4"
			title="退回修改"
		case "5"
			title="取消项目"
		case "6"
			title="通过审核"
	end select
	if typeinfo="6" then
		sql="update "&Application("DBOwner")&".GBI_DOCUMENT set ITEM_TYPE_ID='"&typeinfo&"',ITEM_ACCEPT_DATE=to_date('"&now()&"','yyyy-mm-dd hh24:mi:ss') where ITEM_ID='"&id&"'" 
	else
		sql="update "&Application("DBOwner")&".GBI_DOCUMENT set ITEM_TYPE_ID='"&typeinfo&"' where ITEM_ID='"&id&"'" 
	end if
else
	str="提示：参数传递错误 "
	call gopage(str,0)	
end if


call conn_open(sql)
	str="提示：项目申请已 "&title&""
call gopage1(str,"item_info.asp?id="&id&"")
%>
