<% Response.Expires = -1 %>
<%
	dim sErrMsg
	sErrMsg=Request.QueryString("s")
	if sErrMsg="" then sErrMsg = "对不起，你没有执行本操作的权限"
	sErrMsg=sErrmsg&"。"	
	if instr(1,sErrmsg,"排放冲突") <> 1 then sErrmsg=sErrmsg&"如果任何问题，请您联系系统管理员。"
%>
<html>
<head><meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<meta NAME="GENERATOR" Content="Microsoft Visual Studio 6.0">
<link type="text/css" rel="stylesheet" href="../Library/Default.css">
<script>
	function window.onload()
	{
		try {
			parent.setForm()
			setTimeout("parent.setForm()",500)
		} catch(ex) {}
	}
	function resetWindow()
	{
		if(window.parent!=window) window.parent.location.reload(true)
		else window.history.back()
	}
</script>
<style>
td{color:#fffffa}
</style>
</head>
<body STYLE>
<table style="height:100%;border:3px ridge lightgreen;background-color:#393" cellspacing="10">
<tr><td><div style="width:100%;height:100%;padding:20;background-color:#586400;border:2px ridge lightgreen" cellspacing="0">
<fieldset style="border:4 ridge #6c0;height:1;width:100%;color:ffff55;">
<legend align="center">
<img src="../images/message.gif" style="width:365;height:70" WIDTH="365" HEIGHT="70"></legend>
<div style="text-align:center;font-size:14px;width:100%;height:1;padding:20">
<br>
<%=sErrMsg%>
<div style="height:68;width:33;position:absolute;right:30;top:30">
<img onmousedown="resetWindow()" src="../images/messageback.gif" style="cursor:hand" title="返回上一页面" / WIDTH="58" HEIGHT="33">
</div>
</div>
</fieldset>
</table></td></tr></table>
</body>
</html>
