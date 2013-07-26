<%Response.Expires=-1%>
<html xmlns:v="urn:schemas-microsoft-com:vml" xmlns:o="urn:schemas-microsoft-com:office:office">
<head>
<link type="text/css" rel="stylesheet" href="..\Library\default.css">
<style>
	INPUT {WIDTH:70;HEIGHT:17px;BORDER:1px solid #3c3;color:white;background-color:#393}
	BUTTON {border:1px solid #3C3;background-color:#228b22;color:#3C3;font-size:13px;height:18px;width:130}
	#GridD td,#gridL td {border-bottom:1px solid white}
</style>
</head>
<script language="javascript">
function checkPwd(){
	var pwd=document.form.pwd.value;
	var n_pwd=document.form.New_PWD.value;
	var c_pwd=document.form.Confirm_PWD.value;
	if(pwd=="" || pwd==null){
		alert("请填写密码");
		document.form.pwd.focus(); 
		return false;
	}
	document.form.pwd.focus(); 
	if(check(pwd)==false)return false; 
	
	if(n_pwd=="" || n_pwd==null){
		alert("请填写新密码");
		document.form.New_PWD.focus(); 
		return false;
	}
	document.form.New_PWD.focus();
	if(check(n_pwd)==false)return false; 
	
	if(c_pwd=="" || c_pwd==null){
		alert("请确认新密码");
		document.form.Confirm_PWD.focus(); 
		return false;
	}
	document.form.Confirm_PWD.focus(); 
	if(check(c_pwd)==false)return false; 
	
	if(c_pwd!=n_pwd){
		alert("确认密码错误");
		document.form.Confirm_PWD.focus(); 
		return false;
	}
	
	document.form.action="Change_Pwd_ctrl.asp";  
	document.form.submit(); 
}


function check(obj){
	if(obj.indexOf("'")!=-1){
		alert("密码中不能含有'号");
		return false;
	}
	if(obj.length<4){
		alert("密码不能小于四位")
		return false;
	}
	return true;
}

</script>
<body>
<div id="Layer_left" style="position:absolute;display:block;  width:100%; height:100%; z-index:1; left: 0px; top: 0px">
<form name="form" method="post">
<input type="hidden" name="userid" id="userid">
<script language="javascript">
	document.form.userid.value=parent.document.all['__USER_ID'].value;
</script>
<table cellpadding cellspacing="0" style="height:100%">
<tr><td>
	<table style="width:100%;height:100%" border="0">
	<tr><td style="text-align:center">
		<table style="width:1;background-color:#393;border:2px groove white;padding:10" id="rrLogin">
		<tr>
			<td style="width:1"><br>&nbsp;&nbsp;<nobr>密&nbsp;&nbsp;&nbsp;&nbsp;码：</nobr></td>
			<td><br><input type="PASSWORD" value / id="pwd" name="pwd">&nbsp;&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;&nbsp;新　密码：</td>
			<td><input type="PASSWORD" value / id="New_PWD" name="New_PWD">&nbsp;&nbsp;</td>
		<tr>
		<tr>
			<td>&nbsp;&nbsp;确认密码：</td>
			<td><input type="PASSWORD" value / id="Confirm_PWD" name="Confirm_PWD">&nbsp;&nbsp;</td>
		<tr>
			<td COLSPAN="2" style="text-align:center">&nbsp;&nbsp;<button ONCLICK="return checkPwd()" id="button1" name="button1">修改</button>&nbsp;&nbsp;<br>&nbsp;</td>	
		</table> 
		<br><br><br><br><br><br><br><br><br>
	</td></tr></table>
</td></tr>
</table>
</form>
</div>
<table style="height:100%" cellspacing="0" cellpadding="0">
<tr><td>
<img src="../images/right.gif" style="width:100%;height:100%" />
</td></tr>
</table>

</body>
</html>
