<!--#include file="function.asp"-->
<title>�ر���Ŀ</title>
<body bgcolor=#aaddff leftMargin=0 topMargin=0 >
<%
call checksession1()
userid=split(session("userinfo"),"/@")(0)
username=split(session("userinfo"),"/@")(1)
dept_id=split(session("userinfo"),"/@")(2)
leader=split(session("userinfo"),"/@")(4)
if leader<>"1" then
	str="��ʾ���㲻�ǲ����쵼 "
	call gopage(str,0)
end if
typeinfo=trim(Request("typeinfo"))
id=trim(Request("id"))
if id="" then
	str="��ʾ���������ݴ��� "
	call gopage(str,0)	
end if


sql="update "&Application("DBOwner")&".GBI_DOCUMENT set ITEM_TYPE_ID='7' where ITEM_ID='"&id&"'" 



call conn_open(sql)
	str="��ʾ����Ŀ�ѹر�"
call gopage1(str,"item_info.asp?id="&id&"")
%>
