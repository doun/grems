<!--#include file="function.asp"-->
<title>�޸���Ŀ��չ</title>
<body bgcolor=#aaddff leftMargin=0 topMargin=0 >
<%
call checksession()


id=trim(Request.Form("id"))
impower=trim(Request.Form("impower"))
	if id="" then
		str="��ʾ���������ݳ��� "
		call gopage(str,0)
	end if
	if impower="" then
		str="��ʾ���û����䲻��Ϊ�� "
		call gopage(str,0)
	end if
	
	sql="update "&Application("DBOwner")&".GBI_DOCUMENT set ITEM_IMPOWER_REMARK='"&impower&"' where ITEM_ID='"&id&"'" 
	
	
	call conn_open(sql)

	str="��ʾ���û������޸ĳɹ� "
	call gopage1(str,"item_info.asp?id="&id&"")
%>