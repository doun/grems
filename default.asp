

<%Response.Expires=-1%>
<!--#include file="include/ApplicationAdd.asp"-->
<html xmlns:v="urn:schemas-microsoft-com:vml" xmlns:o="urn:schemas-microsoft-com:office:office">
<head>
<link type="text/css" rel="stylesheet" href="Library\default.css">
<style>
	INPUT {WIDTH:80;HEIGHT:17px;BORDER:1px solid #3c3;color:white;background-color:#393}
	a,BUTTON {border:1px solid #3C3;background-color:#228b22;color:white;font-size:13px;height:16px;width:100%}
	#GridD td,#gridL td {border-bottom:1px solid white}
</style>
<script language="javascript" src="library/default.js"></script>
<script language="javascript" src="library/http.js"></script>
<script language="javascript">
	function DoLoad()
	{		
		var id=txtUserID.value.Trim()
		var pwd=txtPassword.value.Trim()
		if(id=="")
		{
			alert("������������Ա���ţ�")
			return
		}
		if(pwd=="")
		{
			alert("���������������룡")
			return
		}
		rrLogin.style.visibility="hidden"
	
		wLoader.push("USERID",id)
		wLoader.push("PASSWORD",pwd)		
		wLoader.load(res,"include/login.asp",null,"��֤�û���Ϣ")
	}
	function res(doc)
	{	
		var oNode=doc.firstChild	
		var sText=oNode.text
		if(oNode.nodeName=="MESSAGE")
		{
			if(sText!="OK")
			{
				alert("��½ʧ�ܣ�����ȷ����������û���������Ĵ�Сд�Ƿ���ȷ��")
				rrLogin.style.visibility="visible"
			} else {
				frmMain.UserID.value=txtUserID.value.Trim().toUpperCase()
				frmMain.submit()	
			}	
		} else {
			alert("��½ʧ�ܣ������������µ�½��")
			window.location.reload(true)
		}				
	}
	function window.onload()
	{
		new WebLoader("wLoader",true)
		if(parent.globalUserInfo==null)
		{
			rrLogin.style.visibility="visible"
		}
	}
	function document.onkeydown()
	{		
		try {
			if(event.keyCode==13) DoSubMit.click()
			//if(event.keyCode==9) txtPassword.focus()
		} catch (e) {}
	}
	
	var sContent="<table style='width:200;height:100;background-color:#4a4;border:2px groove lightgreen;padding:10' id=rrLogin>"				
	if(window.navigator.appVersion.indexOf("MSIE 6")==-1) {
		sContent+="<TR><TD style='text-align:center'>�Բ���������ʹ��IE6.0���ϰ汾���ʱ�վ��</TD></TR>"
			+"<TR><TD HEIGHT=1><a href='\\\\T1\\Normal\\IE6.0+SP1'><nobr>�����Ŀ¼���������ie6setup.exe���������������</nobr></a></TD></TR>"
	} else {
		sContent+="<col width=50% align=center>"
		+"<tr><td><nobr>�û���</nobr></td>"
		+"	<td><input type=text value='' maxlength=7  id=txtUserID></TD>"
		+"</TR><TR>"
		+"	<TD>���룺</td>"
		+"	<td><input type=PASSWORD value=''  id=txtPassword></TD>"
		+"<TR>"
		+"	<TD COLSPAN=2 style='text-align:center'><BUTTON id=DoSubMit style='width:70' ONCLICK='this.blur();DoLoad()'>��½</BUTTON></TD>	"
	}
	sContent+="</TABLE>"
</script>
</head>
<body>
<table cellpadding="0" cellspacing="0" style="height:100%">
<tr><td style="height:72">
<img src="images/title.gif" style="height:100%;width:100%"  WIDTH="800" HEIGHT="72">
</td></tr>
<tr><td>
	<div style="width:100%;height:100%"><img src="images/right1.gif" style="width:100%;height:100%" WIDTH="800" HEIGHT="378"></div>
	<table style="bottom:0;position:absolute;width:100%;height:100%">
	<tr><td style="text-align:center">
	<script>document.write(sContent)</script>
	</td></tr></table>
</td></tr>
</table>
<form style="display:none" method="post" action="main.asp" id="frmMain">
<input type="hidden" name="UserID" >
</form>
</body>
</html>
