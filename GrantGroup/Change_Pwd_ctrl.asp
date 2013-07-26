<%@ Language=VBScript %>
<%
function check(obj)
	obj=replace(obj,",","")
	if obj="" or isnull(obj) then
		Response.Write "<script language=javascript>"
		Response.Write "alert('数据出错!');"
		Response.Write "window.history.go(-1);"
		Response.Write "</script>"
		Response.End 	
	end if
	check=obj
end function


userid=trim(Request.Form("userid"))
pwd=trim(Request.Form("pwd"))
New_PWD=trim(Request.Form("New_PWD"))
Confirm_PWD=trim(Request.Form("Confirm_PWD"))

'Response.Write userid &"<br>"
'Response.Write pwd &"<br>"
'Response.Write New_PWD &"<br>"
'Response.Write Confirm_PWD &"<br>"
'Response.End 

userid=check(ucase(userid))
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

set conn=server.CreateObject("adodb.connection")
conn.Open Application("GREMS_ConnectionString")
sql="select count(ep_id) from grems_employee where ep_id='"&userid&"' and ep_passwd='"&pwd&"'"
set Rs=conn.Execute(sql)
if Rs(0)<>"1" then
	Response.Write "<script language=javascript>"
	Response.Write "alert('密码输入错误!');"
	Response.Write "window.history.go(-1);"
	Response.Write "</script>"
	Response.End 	
end if
set Rs=nothing
u_sl="update grems_employee set ep_passwd='"&New_PWD&"' where ep_id='"&userid&"'"
conn.Execute(u_sl)
conn.Close 
set conn=nothing

Response.Write "<script language=javascript>"
Response.Write "alert('修改成功,请重新登录!');"
'Response.Write "parent.focus();parent.ExitLogon();"
Response.Write "parent.location.href='../default.asp';"
Response.Write "</script>"
Response.End 	
%>