<link type="text/css" rel="stylesheet" href="css.css">
<title>�ش�������Ŀ��չ��Ϣ����</title>
<script language=javascript>
function logincheck(){
	var userid=document.formlogin.userid.value;
	var password=document.formlogin.password.value;  
	if(userid=="" || userid==null){
		alert("�������û�ID");
		document.formlogin.userid.focus();
		return false;
	} 
	if(password=="" || password==null){
		alert("�������û�����");
		document.formlogin.password.focus();
		return false;
	} 
	document.formlogin.action="login.asp"
	document.formlogin.submit();   
}
</script>
<body bgcolor=#ddf0ff>
<table border=0 width=100% height=100%>
<tr><td align=center>
      <table  border="1" bordercolorlight="#000000" bordercolordark="#ffffff" cellSpacing=0 cellPadding=0 bgcolor=#aaddff>
      <tr><td height=30>&nbsp;&nbsp;<b>*�ش�������Ŀ��չ��Ϣ����*</b>&nbsp;&nbsp;</td></tr>
	  <tr><td>
		<form name=formlogin method="post" onsubmit="return logincheck()">
		 <table border=0 width=100% >
		 <tr><td height=2></td></tr>
		 <tr><td align=right>�û�&nbsp;&nbsp;ID��</td><td><input type=text class=rec_form name=userid id=userid  size=10  maxlength=10></td></tr>
		 <tr><td align=right>�û����룺</td><td><input type=password  class=rec_form  name=password id=password�� size=10  maxlength=10></td></tr>
		 <tr><td height=2></td></tr>
		 <tr><td colspan=2 align=center><input type=submit value="��¼" class=rec_form>&nbsp;&nbsp;&nbsp;&nbsp;<input type=reset value="����" class=rec_form></td></tr>
		 <tr><td height=5></td></form></tr>
		 </table>
	  </td></tr>
	  </table>
</td></tr>
<tr><td height=150></td></tr>
</table>