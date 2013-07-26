<!--#include file="function.asp"-->
<title>删除项目信息</title>
<body bgcolor=#aaddff leftMargin=0 topMargin=0 >
<%
call checksession()


id=trim(Request("id"))
	if id="" then
		str="提示：参数传递出错 "
		call gopage(str,0)
	end if
	
	
	sql="delete from "&Application("DBOwner")&".GBI_DOCUMENT  where ITEM_ID='"&id&"'" 
	
	
	call conn_open(sql)

%>
<script language=javascript>
	alert("提示：项目申请信息删除成功 ")
	window.close()
	opener.location.reload();
</script>