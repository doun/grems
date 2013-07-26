<!--#include file="function.asp"-->
<title>添加项目信息</title>
<body bgcolor=#aaddff leftMargin=0 topMargin=0 >
<%
call checksession()

userid=split(session("userinfo"),"/@")(0)
username=split(session("userinfo"),"/@")(1)
userdept=split(session("userinfo"),"/@")(2)

item_name=trim(Request.Form("item_name"))
reason=trim(Request.Form("reason"))
	if item_name="" then
		str="提示：项目名称不能为空"
		call gopage(str,0)
	end if
	if reason="" then
		str="提示：申请理由不能为空"
		call gopage(str,0)
	end if

sql="select id from "&Application("DBOwner")&".GBI_DOCUMENT   where ITEM_NAME='"&item_name&"' "
sqlcount="select count(id) from "&Application("DBOwner")&".GBI_DOCUMENT   where ITEM_NAME='"&item_name&"' "
call dbQuery(sql,sqlcount,userArray1,userRows1) 
if userRows1<>-1 then
	str="提示：本项目已有用户提交申请 "
	call gopage(str,0)
end if
	
	
sql="select id from "&Application("DBOwner")&".GBI_DOCUMENT   where ITEM_APPLY_ID='"&userid&"' order by id desc"
sqlcount="select count(id) from "&Application("DBOwner")&".GBI_DOCUMENT   where ITEM_APPLY_ID='"&userid&"' order by id desc"
call dbQuery(sql,sqlcount,userArray,userRows) 
if userRows=-1 then
	id=1
else
	id=cint(trim(userArray(0,0)))+1
end if

'item_id=ucase(userid)&year(date())&right("0"&month(date()),2)&right("0"&day(date()),2)&right("00"&id,3)
item_id=ucase(userid)&right("00"&id,3)
sql="insert into "&Application("DBOwner")&".GBI_DOCUMENT (ITEM_ID,ITEM_NAME,ITEM_APPLY_ID,ITEM_APPLY_DEPT,ITEM_APPLY_DATE,ITEM_APPLY_REASON,ID,ITEM_TYPE_ID)"
sql=sql&" values ('"&item_id&"','"&item_name&"','"&userid&"','"&userdept&"',to_date('"&now()&"','yyyy-mm-dd hh24:mi:ss'),'"&reason&"','"&id&"','0')"
call conn_open(sql)

str="提示：项目申请信息提交成功 "
call gopage1(str,"right.asp")
%>