<!--#include file="function.asp"-->
<%
call checksession()
%>
<Script language=javascript>
function checkall() {
		  if (document.form1.item_name.value =="") 
         {
                alert("����д��Ŀ����");
                document.form1.item_name.focus();
                return false; 
         }
         if (document.form1.reason.value =="") 
         {
                alert("����д����ԭ��");
                document.form1.reason.focus();
                return false; 
         }
        
}
</script>
<link type="text/css" rel="stylesheet" href="css.css">
<body bgcolor=#aaddff leftMargin=0 topMargin=0 >
<table border=0 width=100%>
<tr><td height=5></td></tr>
<tr><td>
<form action="apply0.asp" method="post"  name="form1" onsubmit="return checkall()">
	  <table width="99%" border="1" align="center" cellpadding="5" cellspacing="0" bordercolorlight="#A5C8F1" bordercolordark="#ffffff"  bgcolor=#ddf0ff>
	  <tr><td >
	   	  <table width="100%" border="1" align="center" cellpadding="5" cellspacing="0" bordercolorlight="#A5C8F1" bordercolordark="#ffffff" >
		  <tr>
		  <td colspan=2>&nbsp;&nbsp;&nbsp;<font color=blue>��д��Ŀ����<font face=webdings>6</font></font></td>
		  </tr>
		  <!--
		  <tr>
		  <td width=80 align=right>���뵥�ţ�</td><td width=150>&nbsp;<input type=text name=item_id size=20  maxlength=20 class="rec_form"></td>
		  </tr>
		  -->
		  <tr>
		  <td width=80 align=right>��Ŀ���ƣ�</td><td >&nbsp;<input type=text name=item_name size=40  maxlength=40 class="rec_form"></td>
		  </tr>
		   <tr>
		  <td  align=right>����ԭ��</td><td >&nbsp;<textarea name=reason cols=70 rows=14 class="rec_form"></textarea></td>
		  </tr>
		  <tr><td align=center colspan=2 height=40><input type="submit" name="Submit" value=" �� �� �� �� " class="rec_form">
							<input type="reset" name="Submit2" value=" �� �� " class="rec_form">
		</td></form></tr>
		  </table>	
	  </td></tr>
	  </table>	
</td></tr>
</table>
