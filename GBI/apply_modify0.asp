<!--#include file="function.asp"-->
<title>�޸���Ŀ��Ϣ</title>
<body bgcolor=#aaddff leftMargin=0 topMargin=0 >
<%
call checksession()


id=trim(Request.Form("id"))
reason=trim(Request.Form("reason"))
	if id="" then
		str="��ʾ���������ݳ��� "
		call gopage(str,0)
	end if
	if reason="" then
		str="��ʾ���������ɲ���Ϊ�� "
		call gopage(str,0)
	end if
	
	sql="update "&Application("DBOwner")&".GBI_DOCUMENT set ITEM_APPLY_REASON='"&reason&"',ITEM_APPLY_DATE=to_date('"&now()&"','yyyy-mm-dd hh24:mi:ss'),item_type_id=0 where ITEM_ID='"&id&"'" 
	
	
	call conn_open(sql)

	str="��ʾ����Ŀ������Ϣ�޸ĳɹ� "
	call gopage1(str,"item_info.asp?id="&id&"")
%>