 <!--#include file="function.asp"-->
<%
call checksession1()

id=trim(Request("id"))
if id="" then
	str="��ʾ���������ݴ���"
	call gopage1(str,0)
end if
sql="select t1.ITEM_ID,t1.ITEM_NAME,t1.ITEM_APPLY_ID,t2.USER_NAME,t3.ITEM_DEPT_NAME,t1.ITEM_APPLY_DATE,t1.ITEM_ACCEPT_DATE,t2.USER_TEL,t1.ITEM_APPLY_REASON,t1.ITEM_APPLY_PLAN,t1.ITEM_IMPOWER_REMARK,t1.ITEM_DEPT_REMARK,t4.GBI_TYPE_NAME"
sql=sql&" from "&Application("DBOwner")&".GBI_DOCUMENT t1,"&Application("DBOwner")&".GBI_USER t2,"&Application("DBOwner")&".GBI_DEPT t3,"&Application("DBOwner")&".GBI_TYPE t4 where t1.item_type_id=t4.bgi_type_id (+) and t1.ITEM_APPLY_ID=t2.USER_ID and t1.ITEM_APPLY_DEPT=t3.ITEM_DEPT_ID and t1.ITEM_ID='"&id&"'"
sqlcount="select count(t1.ITEM_ID) from "&Application("DBOwner")&".GBI_DOCUMENT t1,"&Application("DBOwner")&".GBI_USER t2,"&Application("DBOwner")&".GBI_DEPT t3,"&Application("DBOwner")&".GBI_TYPE t4 where t1.ITEM_APPLY_ID=t2.USER_ID and t1.ITEM_APPLY_DEPT=t3.ITEM_DEPT_ID and t1.ITEM_ID='"&id&"'"

call dbQuery(sql,sqlcount,userArray1,userRows1) 
if userRows1=-1 then
	str="��ʾ������Ŀ��Ϣ������ "
	call gopage1(str,0)
end if

		if isdate(userArray1(5,i)) then
			sdate=FormatDateTime(userArray1(5,i),2)
		end if
		if isdate(userArray1(6,i)) then
			adate=FormatDateTime(userArray1(6,i),2)
		end if
		
		if isnull(userArray1(12,i)) or userArray1(12,i)="" then
			type_name="��������"
		else
			type_name=userArray1(12,i)
		end if	
%>
<Script language=javascript>
function checkall() {
		 
         if (document.form1.reason.value =="") 
         {
                alert("����д����ԭ��");
                document.form1.reason.focus();
                return false; 
         }
        
}
</script>
<link type="text/css" rel="stylesheet" href="css.css">
<title>�޸���Ŀ����</title>
<body bgcolor=#aaddff leftMargin=0 topMargin=0 >
<table border=0 width=100%>
<tr><td height=5></td></tr>
<tr><td>
<form action="apply_modify0.asp" method="post"  name="form1" onsubmit="return checkall()">
  <table width="99%" border="1" align="center" cellpadding="5" cellspacing="0" bordercolorlight="#A5C8F1" bordercolordark="#ffffff" bgcolor=#ddf0ff>
	  <tr><td >
	   	  <table width="100%" border="1" align="center" cellpadding="2" cellspacing="0" bordercolorlight="#A5C8F1" bordercolordark="#ffffff">
		  <tr>
		  <td colspan=6 >
			<table border=0  cellpadding="0" cellspacing="0" width=100%>
			<tr>
			<td>
			&nbsp;<font color=blue>��Ŀ��Ϣ����<font face=webdings>6</font></font>
			</td>
			<td align=right>
			<font color=red><%=type_name%></font>&nbsp;
			</td>
			</tr>
			</table>
		  </td>
		  </tr>
		  <tr bgcolor=#ffffff>
		  <td align=right width=70><font color=blue>��Ϣ���ţ�</font></td><td width=100 >&nbsp;<%=userArray1(0,0)%></td>
		  <td align=right width=70><font color=blue>��Ŀ���ƣ�</font></td><td colspan=3 >&nbsp;<%=userArray1(1,0)%></td>
		  </tr>
		  <tr bgcolor=#ffffff>
		  <td align=right><font color=blue>�����ˣ�</font></td><td width=100 >&nbsp;<%=ucase(userArray1(2,0))%></td>
		  <td align=right><font color=blue>���벿�ţ�</font></td><td width=140>&nbsp;<%=userArray1(4,0)%></td>
		  <td align=right width=70><font color=blue>�������ڣ�</font></td><td >&nbsp;<%=sdate%></td>
		  </tr>
		   <tr bgcolor=#ffffff>
		  <td align=right><font color=blue>������</font></td><td width=100 >&nbsp;<%=ucase(userArray1(3,0))%></td>
		  <td align=right><font color=blue>��ϵ�绰��</font></td><td width=140>&nbsp;<%=userArray1(7,0)%></td>
		  <td align=right width=70><font color=blue>�ӵ����ڣ�</font></td><td >&nbsp;<%=adate%></td>
		  </tr>
		  <tr><input type=hidden name=id value=<%=id%>>
		  <td  align=right>����ԭ��</td><td colspan=5>&nbsp;<br><textarea name=reason cols=70 rows=14 class="rec_form"><%=userArray1(8,0)%></textarea><br></td>
		  </tr>
		  <tr><td align=center colspan=6 height=40><input type="submit" name="Submit" value=" �ޡ��� �� �� " class="rec_form"> <input type="reset" name="Submit2" value=" �� �� " class="rec_form"> <input type="button" name="button" value=" �� �� " class="rec_form" onclick="window.history.go(-1)">
		  </td></form></tr>
		  
		  
		  </table>
	  </td></tr>
   </table>
 </td></tr>
 </table>
 </body>
