<!--#include file="function.asp"-->
<title>修改项目信息</title>
<body bgcolor=#aaddff leftMargin=0 topMargin=0 >
<%
call checksession()


id=trim(Request.Form("id"))
reason=trim(Request.Form("reason"))
	if id="" then
		str="提示：参数传递出错 "
		call gopage(str,0)
	end if
	if reason="" then
		str="提示：申请理由不能为空 "
		call gopage(str,0)
	end if
	
	sql="update "&Application("DBOwner")&".GBI_DOCUMENT set ITEM_APPLY_REASON='"&reason&"',ITEM_APPLY_DATE=to_date('"&now()&"','yyyy-mm-dd hh24:mi:ss'),item_type_id=0 where ITEM_ID='"&id&"'" 
	
	
	call conn_open(sql)

	str="提示：项目申请信息修改成功 "
	call gopage1(str,"item_info.asp?id="&id&"")
%>