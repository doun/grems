 <!--#include file="function.asp"-->
<%
call checksession()
userid=split(session("userinfo"),"/@")(0)
username=split(session("userinfo"),"/@")(1)
dept_name=split(session("userinfo"),"/@")(3)
leader=split(session("userinfo"),"/@")(4)
if leader="1" then
	leader="[部门领导]"
end if
%>
<link type="text/css" rel="stylesheet" href="css.css">
<title>重大商务项目进展信息跟踪</title>

<body bgcolor="#ddf0ff" leftMargin="0" topMargin="0">
<table border="0" width="100%" height="100%">
<tr><td height="60">
	<table border="0">
	<tr>
	<td align="center" valign="bottom"><table style="filter:glow(color=#0000ff,strength=2)"><font color="#ffff00" size="6"><b>&nbsp;<span style="font-family:黑体">重大商务项目进展信息跟踪</span></b></font></table></td>
	<td>
	<table border="0">
		<tr><td><table border="0　cellSpacing=0" cellPadding="0"><tr><td >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/dot.gif" WIDTH="7" HEIGHT="7"></td><td><b>&nbsp;用户　ID：</b><font color="blue"><%=ucase(userid)%></font>
		</td></tr></table></td></tr>
		<tr><td><table border="0　cellSpacing=0" cellPadding="0"><tr><td >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/dot.gif" WIDTH="7" HEIGHT="7"></td><td><b>&nbsp;用户姓名：</b><font color="blue"><%=username%><%=leader%></font>
		&nbsp;&nbsp;&nbsp;<img src="images/dot.gif" WIDTH="7" HEIGHT="7"></td><td><b>&nbsp;所在部门：</b><font color="blue"><%=dept_name%></font>
		</td></tr></table></td></tr>
	</table>
	</td>
	</tr>
	</table>
</td></tr>
<tr><td align="center">
	<table border="0" cellSpacing="0" cellPadding="0" width="99%" height="100%">
	<tr><td>
	<td valign="top" width="160">
	<iframe id="LEFTFRAME" src="left.asp" name="LEFTFRAME" width="100%" height="100%" marginheight="0" marginwidth="0" scrolling="no" border="0" frameborder="no"></iframe>
	</td>
	<td width="8"></td>
	<td valign="top">
	<iframe id="RIGHTFRAME" src="right.asp" name="RIGHTFRAME" width="100%" height="100%" marginheight="0" marginwidth="0" scrolling="auto" border="0" frameborder="no"></iframe>
	</td>
	</tr>
	</table>
</td></tr>
<tr><td height="20"></td></tr>
</table>
