<!--#include file="function.asp"-->
<title>ɾ����Ŀ��Ϣ</title>
<body bgcolor=#aaddff leftMargin=0 topMargin=0 >
<%
call checksession()


id=trim(Request("id"))
	if id="" then
		str="��ʾ���������ݳ��� "
		call gopage(str,0)
	end if
	
	
	sql="delete from "&Application("DBOwner")&".GBI_DOCUMENT  where ITEM_ID='"&id&"'" 
	
	
	call conn_open(sql)

%>
<script language=javascript>
	alert("��ʾ����Ŀ������Ϣɾ���ɹ� ")
	window.close()
	opener.location.reload();
</script>