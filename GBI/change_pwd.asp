<!--#include file="function.asp"-->
<%
call checksession()
userid=split(session("userinfo"),"/@")(0)
username=split(session("userinfo"),"/@")(1)
dept_id=split(session("userinfo"),"/@")(2)
dept_name=split(session("userinfo"),"/@")(3)
leader=split(session("userinfo"),"/@")(4)
%>
<script language="javascript">
function checkPwd(){
	var pwd=document.form.pwd.value;
	var n_pwd=document.form.n_pwd.value;
	var c_pwd=document.form.c_pwd.value;
	if(pwd=="" || pwd==null){
		alert("����д������");
		document.form.pwd.focus(); 
		return false;
	}
	document.form.pwd.focus(); 
	if(check(pwd)==false)return false; 
	
	if(n_pwd=="" || n_pwd==null){
		alert("����д������");
		document.form.n_pwd.focus(); 
		return false;
	}
	document.form.n_pwd.focus();
	if(check(n_pwd)==false)return false; 
	
	if(c_pwd=="" || c_pwd==null){
		alert("��ȷ��������");
		document.form.c_pwd.focus(); 
		return false;
	}
	document.form.c_pwd.focus(); 
	if(check(c_pwd)==false)return false; 
	
	if(c_pwd!=n_pwd){
		alert("ȷ���������");
		document.form.c_pwd.focus(); 
		return false;
	}
	
	document.form.action="Change_Pwd_ctrl.asp";  
	document.form.submit(); 
}


function check(obj){
	if(obj.indexOf("'")!=-1){
		alert("�����в��ܺ���'��");
		return false;
	}
	if(obj.length<2){
		alert("���벻��С����λ")
		return false;
	}
	return true;
}

</script>
<link type="text/css" rel="stylesheet" href="css.css">

<body bgcolor=#aaddff leftMargin=0 topMargin=0 >
<table border=0 width=100%>
<tr><td height=5></td></tr>
<tr><td>
<form name=form method=post onsubmit="return checkPwd()">
  <table width="99%" border="1" align="center" cellpadding="5" cellspacing="0" bordercolorlight="#A5C8F1" bordercolordark="#ffffff" bgcolor=#ddf0ff>
	  <tr><td >
	   	  <table width="100%" border="1" align="center" cellpadding="2" cellspacing="0" bordercolorlight="#A5C8F1" bordercolordark="#ffffff">
		  <tr>
		  <td colspan=2 id=t11>&nbsp;&nbsp;&nbsp;<font color=blue>�޸�����<font face=webdings>6</font></font></td>
		  </tr>
		  <tr bgcolor=#ffffff><td align=right width=45%>�����룺</td><td><input type=password  class=rec_form  name=pwd id=pwd�� size=10  maxlength=10></td></tr>
  		  <tr bgcolor=#ffffff><td align=right>�����룺</td><td><input type=password  class=rec_form  name=n_pwd id=n_pwd�� size=10  maxlength=10></td></tr>
  		  <tr bgcolor=#ffffff><td align=right>ȷ�������룺</td><td><input type=password  class=rec_form  name=c_pwd id=c_pwd�� size=10  maxlength=10></td></tr>
   		  <tr ><td align=center colspan=2 ��height=30><input type=submit value=" ȷ �� " class=rec_form id=submit1 name=submit1>&nbsp;&nbsp;&nbsp;&nbsp;<input type=reset value=" �� �� " class=rec_form id=reset1 name=reset1></td></tr>
		  </table>
	  </td></tr>
	  </form>
   </table>
 </td></tr>
 </table>
 </body>
