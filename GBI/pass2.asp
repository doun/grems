<!--#include file="function.asp"-->
<title>�����Ŀ��Ϣ</title>
<body bgcolor=#aaddff leftMargin=0 topMargin=0 >
<%
call checksession1()
userid=split(session("userinfo"),"/@")(0)
username=split(session("userinfo"),"/@")(1)
dept_id=split(session("userinfo"),"/@")(2)
leader=split(session("userinfo"),"/@")(4)
if dept_id<>"2" then
	str="��ʾ���㲻�Ǻ�ͬ���� "
	call gopage(str,0)
end if
typeinfo=trim(Request("typeinfo"))
id=trim(Request("id"))
if typeinfo="" or id="" then
	str="��ʾ���������ݴ��� "
	call gopage(str,0)	
end if

if typeinfo="4" or  typeinfo="5" or  typeinfo="6" then
	select case typeinfo
		case "4"
			title="�˻��޸�"
		case "5"
			title="ȡ����Ŀ"
		case "6"
			title="ͨ�����"
	end select
	if typeinfo="6" then
		sql="update "&Application("DBOwner")&".GBI_DOCUMENT set ITEM_TYPE_ID='"&typeinfo&"',ITEM_ACCEPT_DATE=to_date('"&now()&"','yyyy-mm-dd hh24:mi:ss') where ITEM_ID='"&id&"'" 
	else
		sql="update "&Application("DBOwner")&".GBI_DOCUMENT set ITEM_TYPE_ID='"&typeinfo&"' where ITEM_ID='"&id&"'" 
	end if
else
	str="��ʾ���������ݴ��� "
	call gopage(str,0)	
end if


call conn_open(sql)
	str="��ʾ����Ŀ������ "&title&""
call gopage1(str,"item_info.asp?id="&id&"")
%>
