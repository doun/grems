 <!--#include file="function.asp"-->
<%
call checksession1()

id=trim(Request("id"))
if id="" then
	str="提示：参数传递错误"
	call gopage1(str,0)
end if
sql="select t1.ITEM_ID,t1.ITEM_NAME,t1.ITEM_APPLY_ID,t2.USER_NAME,t3.ITEM_DEPT_NAME,t1.ITEM_APPLY_DATE,t1.ITEM_ACCEPT_DATE,t2.USER_TEL,t1.ITEM_APPLY_REASON,t1.ITEM_APPLY_PLAN,t1.ITEM_IMPOWER_REMARK,t1.ITEM_DEPT_REMARK,t4.GBI_TYPE_NAME"
sql=sql&" from "&Application("DBOwner")&".GBI_DOCUMENT t1,"&Application("DBOwner")&".GBI_USER t2,"&Application("DBOwner")&".GBI_DEPT t3,"&Application("DBOwner")&".GBI_TYPE t4 where t1.item_type_id=t4.bgi_type_id (+) and t1.ITEM_APPLY_ID=t2.USER_ID and t1.ITEM_APPLY_DEPT=t3.ITEM_DEPT_ID and t1.ITEM_ID='"&id&"'"
sqlcount="select count(t1.ITEM_ID) from "&Application("DBOwner")&".GBI_DOCUMENT t1,"&Application("DBOwner")&".GBI_USER t2,"&Application("DBOwner")&".GBI_DEPT t3,"&Application("DBOwner")&".GBI_TYPE t4 where t1.ITEM_APPLY_ID=t2.USER_ID and t1.ITEM_APPLY_DEPT=t3.ITEM_DEPT_ID and t1.ITEM_ID='"&id&"'"

call dbQuery(sql,sqlcount,userArray1,userRows1) 
if userRows1=-1 then
	str="提示：本项目信息不存在 "
	call gopage1(str,0)
end if

		if isdate(userArray1(5,i)) then
			sdate=FormatDateTime(userArray1(5,i),2)
		end if
		if isdate(userArray1(6,i)) then
			adate=FormatDateTime(userArray1(6,i),2)
		end if
		
		if isnull(userArray1(12,i)) or userArray1(12,i)="" then
			type_name="正在申请"
		else
			type_name=userArray1(12,i)
		end if	
%>
<Script language=javascript>
function checkall() {
		 
         if (document.form1.reason.value =="") 
         {
                alert("请填写申请原因");
                document.form1.reason.focus();
                return false; 
         }
        
}
</script>
<link type="text/css" rel="stylesheet" href="css.css">
<title>修改项目申请</title>
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
			&nbsp;<font color=blue>项目信息内容<font face=webdings>6</font></font>
			</td>
			<td align=right>
			<font color=red><%=type_name%></font>&nbsp;
			</td>
			</tr>
			</table>
		  </td>
		  </tr>
		  <tr bgcolor=#ffffff>
		  <td align=right width=70><font color=blue>信息单号：</font></td><td width=100 >&nbsp;<%=userArray1(0,0)%></td>
		  <td align=right width=70><font color=blue>项目名称：</font></td><td colspan=3 >&nbsp;<%=userArray1(1,0)%></td>
		  </tr>
		  <tr bgcolor=#ffffff>
		  <td align=right><font color=blue>申请人：</font></td><td width=100 >&nbsp;<%=ucase(userArray1(2,0))%></td>
		  <td align=right><font color=blue>申请部门：</font></td><td width=140>&nbsp;<%=userArray1(4,0)%></td>
		  <td align=right width=70><font color=blue>申请日期：</font></td><td >&nbsp;<%=sdate%></td>
		  </tr>
		   <tr bgcolor=#ffffff>
		  <td align=right><font color=blue>姓名：</font></td><td width=100 >&nbsp;<%=ucase(userArray1(3,0))%></td>
		  <td align=right><font color=blue>联系电话：</font></td><td width=140>&nbsp;<%=userArray1(7,0)%></td>
		  <td align=right width=70><font color=blue>接单日期：</font></td><td >&nbsp;<%=adate%></td>
		  </tr>
		  <tr><input type=hidden name=id value=<%=id%>>
		  <td  align=right>申请原因：</td><td colspan=5>&nbsp;<br><textarea name=reason cols=70 rows=14 class="rec_form"><%=userArray1(8,0)%></textarea><br></td>
		  </tr>
		  <tr><td align=center colspan=6 height=40><input type="submit" name="Submit" value=" 修　改 申 请 " class="rec_form"> <input type="reset" name="Submit2" value=" 重 置 " class="rec_form"> <input type="button" name="button" value=" 返 回 " class="rec_form" onclick="window.history.go(-1)">
		  </td></form></tr>
		  
		  
		  </table>
	  </td></tr>
   </table>
 </td></tr>
 </table>
 </body>
