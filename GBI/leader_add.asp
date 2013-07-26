 <!--#include file="function.asp"-->
<%
call checksession1()
userid=split(session("userinfo"),"/@")(0)
username=split(session("userinfo"),"/@")(1)
dept_id=split(session("userinfo"),"/@")(2)
leader=split(session("userinfo"),"/@")(4)

if leader<>"1" then
	str="提示：你不是部门领导 "
	call gopage(str,0)
end if
id=trim(Request("id"))
	if id="" then
		str="提示：参数传递错误"
		call gopage1(str,0)
	end if
sql="select t1.ITEM_ID,t1.ITEM_NAME,t1.ITEM_APPLY_ID,t2.USER_NAME,t3.ITEM_DEPT_NAME,t1.ITEM_APPLY_DATE,t1.ITEM_ACCEPT_DATE,t2.USER_TEL,t1.ITEM_APPLY_REASON,t1.ITEM_APPLY_PLAN,t1.ITEM_IMPOWER_REMARK,t1.ITEM_DEPT_REMARK,t1.ITEM_TYPE_ID,t4.GBI_TYPE_NAME,t1.item_pass_id1,t1.item_pass_id2"
sql=sql&" from "&Application("DBOwner")&".GBI_DOCUMENT t1,"&Application("DBOwner")&".GBI_USER t2,"&Application("DBOwner")&".GBI_DEPT t3,"&Application("DBOwner")&".GBI_TYPE t4 where t1.item_type_id=t4.bgi_type_id (+) and t1.ITEM_APPLY_ID=t2.USER_ID and t1.ITEM_APPLY_DEPT=t3.ITEM_DEPT_ID and t1.ITEM_ID='"&id&"'"
sqlcount="select count(t1.ITEM_ID) from "&Application("DBOwner")&".GBI_DOCUMENT t1,"&Application("DBOwner")&".GBI_USER t2,"&Application("DBOwner")&".GBI_DEPT t3,"&Application("DBOwner")&".GBI_TYPE t4 where t1.ITEM_APPLY_ID=t2.USER_ID and t1.ITEM_APPLY_DEPT=t3.ITEM_DEPT_ID and t1.ITEM_ID='"&id&"'"
'Response.Write sql
call dbQuery(sql,sqlcount,userArray1,userRows1) 
if userRows1=-1 then
	str="提示：本项目信息不存在 "
	call gopage1(str,0)
end if

function HTMLFormat(sInput)
dim sAns
if sInput="" or isnull(sInput) then
	sAns=sInput
else
	sAns = replace(sInput," ","&nbsp;")
	sAns = replace(sAns,chr(34),"&quot;")
	sAns = replace(sAns,"<","&lt;&nbsp;")
	sAns = replace(sAns,">","&gt;")
	sAns = replace(sAns,vbcrlf,"<br>")
	sAns = replace(sAns,"'","''")
end if
HTMLFormat = sAns
end function
		
		if isdate(userArray1(5,i)) then
			sdate=FormatDateTime(userArray1(5,i),2)
		end if
		if isdate(userArray1(6,i)) then
			adate=FormatDateTime(userArray1(6,i),2)
		end if
		
		if isnull(userArray1(13,i)) or userArray1(13,i)=""  then
			type_name="正在申请"
		else
			type_name=userArray1(13,i)
		end if		
%>
<title><%=userArray1(1,0)%></title>
<link type="text/css" rel="stylesheet" href="css.css">
<Script language=javascript>
function checkall() {
		 
         if (document.form1.remark.value =="") 
         {
                alert("请填写领导批示");
                document.form1.remark.focus();
                return false; 
         }
        
}
</script>
<body bgcolor=#aaddff leftMargin=0 topMargin=0 >
<form action="leader_add0.asp" method="post"  name="form1" onsubmit="return checkall()">
<table border=0 width=100%>
<tr><td height=5></td></tr>
<tr><td>
  <table width="99%" border="1" align="center" cellpadding="5" cellspacing="0" bordercolorlight="#A5C8F1" bordercolordark="#ffffff" bgcolor=#ddf0ff>
	  <tr><td >
	   	  <table width="100%" border="1" align="center" cellpadding="2" cellspacing="0" bordercolorlight="#A5C8F1" bordercolordark="#ffffff">
		  <tr>
		  <td colspan=6 >
			<table border=0  cellpadding="0" cellspacing="0" width=100%>
			<tr>
			<td>
			&nbsp;<font color=blue>添加领导批示<font face=webdings>6</font></font>
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
		  <tr bgcolor=#ffffff>
		  <td align=right><font color=blue>申请原因：</font></td><td colspan=5 align="center">
			<table width="99%" border="0"  cellpadding="5" cellspacing="0" >
			<tr><td><%=HTMLFormat(userArray1(8,0))%>&nbsp;</td></tr>
			</table>
		  </td>
		  </tr>
		  <tr bgcolor=#ffffff>
		  <td align=right><font color=blue>项目进展：</font></td><td colspan=5 align="center">
			<table width="99%" border="0"  cellpadding="5" cellspacing="0" >
			<tr><td><%=HTMLFormat(userArray1(9,0))%>&nbsp;</td></tr>
			</table>
		  </td>
		  </tr>
		  <tr bgcolor=#ffffff>
		  <td align=right><font color=blue>用户补充：</font></td><td colspan=5 align="center">
			<table width="99%" border="0"  cellpadding="5" cellspacing="0" >
			<tr><td><%=HTMLFormat(userArray1(10,0))%>&nbsp;</td></tr>
			</table>
		  </td>
		  </tr>
		  <!--
		   <tr bgcolor=#ffffff>
		  <td align=right><font color=blue>领导批示：</font></td><td colspan=5 align="center">
			<table width="99%" border="0"  cellpadding="5" cellspacing="0" >
			<tr><td><%=HTMLFormat(userArray1(11,0))%>&nbsp;</td></tr>
			</table>
		  </td>
		  </tr>
		  -->
		</tr>
		  <tr><input type=hidden name=id value=<%=id%>>
		  <td  align=right>领导批示：</td><td colspan=5>&nbsp;<br><textarea name=remark cols=70 rows=14 class="rec_form"><%=userArray1(11,0)%></textarea><br></td>
		  </tr>
		  <tr><td align=center colspan=6 height=40><input type="submit" name="Submit" value=" 修　改 领 导 批 示 " class="rec_form"> <input type="reset" name="Submit2" value=" 重 置 " class="rec_form"> <input type="button" name="button" value=" 返 回 " class="rec_form" onclick="window.history.go(-1)">
		  </td></form></tr>
			</table>
		  </td>
		  </tr>		  
		  </table>
	  </td></tr>
   </table>
 </td></tr>
 </table>
 </body>