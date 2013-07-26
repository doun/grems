 <!--#include file="function.asp"-->
<%
userid=trim(Request.Form("userid"))
password=trim(Request.Form("password"))

if userid="" or isnull(userid) then
	str="请填写用户ID"
	call gopage(str,0)
end if
if password="" or isnull(password) then
	str="请填写用户ID"
	call gopage(str,0)
end if
userid=lcase(userid)
password=lcase(password)

sql="select a.USER_PASSWORD,a.USER_NAME,b.ITEM_DEPT_ID,b.ITEM_DEPT_NAME,a.USER_PURVIEW from "&Application("DBOwner")&".GBI_USER  a,"&Application("DBOwner")&".GBI_DEPT b where a.USER_ID='"&userid&"' and b.ITEM_DEPT_ID=a.DETP_ID"
sqlcount="select  count(a.USER_ID) from "&Application("DBOwner")&".GBI_USER a,"&Application("DBOwner")&".GBI_DEPT b where a.USER_ID='"&userid&"' and b.ITEM_DEPT_ID=a.DETP_ID"
call dbQuery(sql,sqlcount,userArray,userRows) 
if userRows=-1 then
	str="提示：用户不存在\n\n如要登录本系统,请与系统管理员联系 "
	call gopage(str,0)
else
	if lcase(trim(userArray(0,0)))<>password then
		str="提示：密码错误"
		call gopage(str,0)
	end if
	username=trim(userArray(1,0))
	dept_id=trim(userArray(2,0))
	dept_name=trim(userArray(3,0))
	leader=trim(userArray(4,0))
end if

session("userinfo")=userid&"/@"&username&"/@"&dept_id&"/@"&dept_name&"/@"&leader
Response.Redirect "main.asp"
%>