<!--#include file="function.asp"-->
<title>�޸��쵼��ʾ</title>
<body bgcolor=#aaddff leftMargin=0 topMargin=0 >
<%
call checksession()


id=trim(Request.Form("id"))
remark=trim(Request.Form("remark"))
	if id="" then
		str="��ʾ���������ݳ��� "
		call gopage(str,0)
	end if
	if remark="" then
		str="��ʾ���쵼��ʾ����Ϊ�� "
		call gopage(str,0)
	end if
	
	sql="update "&Application("DBOwner")&".GBI_DOCUMENT set ITEM_DEPT_REMARK='"&remark&"' where ITEM_ID='"&id&"'" 
	
	
	call conn_open(sql)

	str="��ʾ���쵼��ʾ�޸ĳɹ� "
	call gopage1(str,"item_info.asp?id="&id&"")
%>