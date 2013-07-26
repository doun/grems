<!--#include file="function.asp"-->
<title>修改用户密码</title>
<body bgcolor=#aaddff leftMargin=0 topMargin=0 >
<%
call checksession()
userid=split(session("userinfo"),"/@")(0)
username=split(session("userinfo"),"/@")(1)
dept_id=split(session("userinfo"),"/@")(2)
leader=split(session("userinfo"),"/@")(4)

function check(obj)
	obj=ucase(replace(obj,",",""))
	if obj="" or isnull(obj) then
		Response.Write "<script language=javascript>"
		Response.Write "alert('数据出错!');"
		Response.Write "window.history.go(-1);"
		Response.Write "</script>"
		Response.End 	
	end if
	check=obj
end function


pwd=trim(Request.Form("pwd"))
New_PWD=trim(Request.Form("n_pwd"))
Confirm_PWD=trim(Request.Form("c_pwd"))

'Response.Write userid &"<br>"
'Response.Write pwd &"<br>"
'Response.Write New_PWD &"<br>"
'Response.Write Confirm_PWD &"<br>"
'Response.End 

userid=check(userid)
pwd=check(pwd)
New_PWD=check(New_PWD)
Confirm_PWD=check(Confirm_PWD)

if New_PWD<>Confirm_PWD then
	Response.Write "<script language=javascript>"
	Response.Write "alert('新密码确认错误!');"
	Response.Write "window.history.go(-1);"
	Response.Write "</script>"
	Response.End 	
end if

userid=lcase(userid)
pwd=lcase(pwd)
New_PWD=LCASE(New_PWD)
set conn=server.CreateObject("adodb.connection")
conn.Open Application("GREMS_ConnectionString")
sql="select count(user_id) from  "&Application("DBOwner")&".gbi_user where user_id='"&userid&"' and user_password='"&pwd&"'"
set Rs=conn.Execute(sql)
if Rs(0)<>"1" then
	Response.Write "<script language=javascript>"
	Response.Write "alert('提示信息：密码输入错误 ');"
	Response.Write "window.history.go(-1);"
	Response.Write "</script>"
	Response.End 	
end if
set Rs=nothing
u_sl="update "&Application("DBOwner")&".gbi_user set user_password='"&New_PWD&"' where user_id='"&userid&"'"
conn.Execute(u_sl)
conn.Close 
set conn=nothing

Response.Write "<script language=javascript>"
Response.Write "alert('提示信息：密码修改成功,请重新登录!');"
'Response.Write "window.history.go(-1);"
Response.Write "top.window.location.href='exit.asp';"
Response.Write "</script>"
Response.End 	
%>