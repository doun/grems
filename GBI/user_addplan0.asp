<!--#include file="function.asp"-->
<title>�޸���Ŀ��չ</title>
<body bgcolor=#aaddff leftMargin=0 topMargin=0 >
<%
call checksession()


id=trim(Request.Form("id"))
plan=trim(Request.Form("plan"))
	if id="" then
		str="��ʾ���������ݳ��� "
		call gopage(str,0)
	end if
	if plan="" then
		str="��ʾ����Ŀ��չ����Ϊ�� "
		call gopage(str,0)
	end if
	plan=plan&vbcrlf
	plan=plan&"("&now()&")"
	plan=plan&"@@"
	sql="update "&Application("DBOwner")&".GBI_DOCUMENT set ITEM_APPLY_PLAN=ITEM_APPLY_PLAN || '"&plan&"' where ITEM_ID='"&id&"'" 
	
	
	call conn_open(sql)

	str="��ʾ����Ŀ��չ�޸ĳɹ� "
	call gopage1(str,"item_info.asp?id="&id&"")
%>