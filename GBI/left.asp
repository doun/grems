 <!--#include file="function.asp"-->
<%
call checksession()
userid=split(session("userinfo"),"/@")(0)
username=split(session("userinfo"),"/@")(1)
dept_id=split(session("userinfo"),"/@")(2)
leader=split(session("userinfo"),"/@")(4)
%>
<link type="text/css" rel="stylesheet" href="css.css">
<body bgcolor=#aaddff leftMargin=0 topMargin=0 >
<table border=0 width=100%>
<tr><td height=20></td></tr>
<%if dept_id="1" or  dept_id="2"  then%>
<tr><td ><table border=0　cellSpacing=0 cellPadding=0><tr><td align=right>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/file.png"></td><td>&nbsp;<a href="right.asp" class=d target=RIGHTFRAME>待审核项目</td></tr></table></td></tr>
<%elseif leader="1" then%>
<tr><td ><table border=0　cellSpacing=0 cellPadding=0><tr><td align=right>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/file.png"></td><td>&nbsp;<a href="right.asp" class=d target=RIGHTFRAME>部门项目</td></tr></table></td></tr>
<%else%>
<tr><td ><table border=0　cellSpacing=0 cellPadding=0><tr><td align=right>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/file.png"></td><td>&nbsp;<a href="apply.asp" class=d target=RIGHTFRAME>项目申请</td></tr></table></td></tr>
<tr><td ><table border=0　cellSpacing=0 cellPadding=0><tr><td align=right>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/file.png"></td><td>&nbsp;<a href="right.asp" class=e target=RIGHTFRAME>项目列表</td></tr></table></td></tr>
<%end if%>
<tr><td ><table border=0　cellSpacing=0 cellPadding=0><tr><td align=right>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/file.png"></td><td>&nbsp;<a href="right.asp?sort=1" class=e target=RIGHTFRAME>已批准项目</td></tr></table></td></tr>
<%if dept_id<>"1" and  dept_id<>"2" then%>
<tr><td ><table border=0　cellSpacing=0 cellPadding=0><tr><td align=right>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/file.png"></td><td>&nbsp;<a href="right.asp?sort=2" class=e target=RIGHTFRAME>已关闭项目</td></tr></table></td></tr>
<%end if%>
<tr><td ><table border=0　cellSpacing=0 cellPadding=0><tr><td align=right>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/file.png"></td><td>&nbsp;<a href="change_pwd.asp" class=e target=RIGHTFRAME>修改密码</td></tr></table></td></tr>
<tr><td ><table border=0　cellSpacing=0 cellPadding=0><tr><td align=right>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/file.png"></td><td>&nbsp;<a href="exit.asp" class=e target=_top>注销/退出</td></tr></table></td></tr>

</table>

