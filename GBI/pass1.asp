<!--#include file="function.asp"-->
<title>�����Ŀ��Ϣ</title>
<body bgcolor=#aaddff leftMargin=0 topMargin=0 >
<%
call checksession1()
userid=split(session("userinfo"),"/@")(0)
username=split(session("userinfo"),"/@")(1)
dept_id=split(session("userinfo"),"/@")(2)
leader=split(session("userinfo"),"/@")(4)
if dept_id<>"1" then
	str="��ʾ���㲻������Ƴ� "
	call gopage(str,0)
end if
typeinfo=trim(Request("typeinfo"))
id=trim(Request("id"))
if typeinfo="" or id="" then
	str="��ʾ���������ݴ��� "
	call gopage(str,0)	
end if

if typeinfo="1" or  typeinfo="2" or  typeinfo="3" then
	select case typeinfo
		case "1"
			title="�˻��޸�"
		case "2"
			title="ȡ����Ŀ"
		case "3"
			title="ͨ�����"
	end select
	sql="update "&Application("DBOwner")&".GBI_DOCUMENT set ITEM_TYPE_ID='"&typeinfo&"' where ITEM_ID='"&id&"'" 
else
	str="��ʾ���������ݴ��� "
	call gopage(str,0)	
end if


call conn_open(sql)
	str="��ʾ����Ŀ������ "&title&""
call gopage1(str,"item_info.asp?id="&id&"")
%>
