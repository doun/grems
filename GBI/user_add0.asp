<!--#include file="function.asp"-->
<title>修改项目进展</title>
<body bgcolor=#aaddff leftMargin=0 topMargin=0 >
<%
call checksession()


id=trim(Request.Form("id"))
impower=trim(Request.Form("impower"))
	if id="" then
		str="提示：参数传递出错 "
		call gopage(str,0)
	end if
	if impower="" then
		str="提示：用户补充不能为空 "
		call gopage(str,0)
	end if
	
	sql="update "&Application("DBOwner")&".GBI_DOCUMENT set ITEM_IMPOWER_REMARK='"&impower&"' where ITEM_ID='"&id&"'" 
	
	
	call conn_open(sql)

	str="提示：用户补充修改成功 "
	call gopage1(str,"item_info.asp?id="&id&"")
%>