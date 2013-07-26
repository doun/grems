 <!--#include file="function.asp"-->
<%
call checksession1()
userid=split(session("userinfo"),"/@")(0)
username=split(session("userinfo"),"/@")(1)
dept_id=split(session("userinfo"),"/@")(2)
leader=split(session("userinfo"),"/@")(4)

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
	if right(sInput,5)=vbcrlf then
		sInput=left(sInput,len(sInput)-5)
	end if
	sAns = replace(sInput," ","&nbsp;")
	sAns = replace(sAns,chr(34),"&quot;")
	sAns = replace(sAns,"<","&lt;&nbsp;")
	sAns = replace(sAns,">","&gt;")
	sAns = replace(sAns,vbcrlf,"<br>")
	sAns = replace(sAns,"'","''")
	sAns = replace(sAns,"@@","<hr width=90% color=#A5C8F1>")
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
<script language=javascript>
function Delinfo(){
    if(confirm('您确认要删除申请信息吗？\n\n点确定删除.\n\n点取消放弃.')){
    window.location.href ='apply_del.asp?id=<%=id%>';
    }
}

function pass1(str,num){
	if(confirm(str)){
		window.location.href ="pass1.asp?id=<%=id%>&typeinfo="+num+"";
    }
}

function pass2(str,num){
	if(confirm(str)){
		window.location.href ="pass2.asp?id=<%=id%>&typeinfo="+num+"";
    }
}
function leader(str){
	if(confirm(str)){
		window.location.href ="isover.asp?id=<%=id%>";
    }
}
</script>
<body bgcolor=#aaddff leftMargin=0 topMargin=0 >
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
		  <tr bgcolor=#ffffff>
		  <td align=right><font color=blue>申请原因：</font></td><td colspan=5 align="center">
			<table width="99%" border="0"  cellpadding="5" cellspacing="0" >
			<tr><td><%=HTMLFormat(userArray1(8,0))%>&nbsp;</td></tr>
			</table>
		  </td>
		  </tr>
		  <%if not isnuLL(userArray1(12,0)) and userArray1(12,0)>="6" then%>
		  <tr bgcolor=#ffffff>
		  <td align=right><font color=blue>项目进展：</font></td><td colspan=5 align="center">
			<table width="99%" border="0"  cellpadding="5" cellspacing="0" >
			<tr><td>
			<%if userArray1(9,0)<>"" and not isnull(userArray1(9,0)) then%>
			<br>
			<%end if%>
			<%=HTMLFormat(userArray1(9,0))%>&nbsp;</td></tr>
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
		   <tr bgcolor=#ffffff>
		  <td align=right><font color=blue>领导批示：</font></td><td colspan=5 align="center">
			<table width="99%" border="0"  cellpadding="5" cellspacing="0" >
			<tr><td><%=HTMLFormat(userArray1(11,0))%>&nbsp;</td></tr>
			</table>
		  </td>
		  </tr>
		  <%end if%>
		   <tr bgcolor=#ffffff>
		  <td align=right height=15 colspan=6>
		  </td>
		  </tr>
		  <tr>
		  <td colspan=6 align=right>
			<table width="99%" border="0"  cellpadding="5" cellspacing="0" >
			<tr>
			<td>
			<%if isnuLL(userArray1(12,0)) or userArray1(12,0)=<"6" then  '不否跟踪项目
				if dept_id="1" and  (userArray1(12,0)="" or isnull(userArray1(12,0)) or userArray1(12,0)="0" ) then%>
					<input type="button" name="button" value=" 通过审核 " class="rec_form " onclick='return pass1("是否通过审核?",3)'>
					<input type="button" name="button" value=" 退回修改 " class="rec_form " onclick='return pass1("是否退回修改?",1)'>
					<input type="button" name="button" value=" 取消项目 " class="rec_form " onclick='return pass1("是否取消项目?",2)'>		
				<%end if%>
				<%if dept_id="2" and  userArray1(12,0)="3" then%>
					<input type="button" name="button" value=" 通过审核 " class="rec_form " onclick='return pass2("是否通过审核?",6)'>
					<input type="button" name="button" value=" 退回修改 " class="rec_form " onclick='return pass2("是否退回修改?",4)'>
					<input type="button" name="button" value=" 取消项目 " class="rec_form " onclick='return pass2("是否取消项目?",5)'>		
				<%end if%>
				<%if leader="1" and  userArray1(12,0)="6" then%>
					<input type="button" name="button" value=" 修改批示 " class="rec_form"  onclick='window.location.href="leader_add.asp?id=<%=id%>"'>
					<input type="button" name="button" value=" 关闭项目 " class="rec_form " onclick='return leader("是否关闭项目?")'>
				<%end if%>
				<%if userid=userArray1(2,0) then%>
					<%if userArray1(12,0)="0" or userArray1(12,0)="1" or userArray1(12,0)="2"  or userArray1(12,0)="4" or userArray1(12,0)="5" then  %>
						<input type="button" name="button" value=" 修改申请信息 " class="rec_form " onclick='window.location.href="apply_modify.asp?id=<%=id%>"'>
					<%end if%>
					<%if userArray1(12,0)="6" then%>
						<input type="button" name="button" value=" 修改项目进展 " class="rec_form"  onclick='window.location.href="user_addplan.asp?id=<%=id%>"'>
						<input type="button" name="button" value=" 修改补充 " class="rec_form " onclick='window.location.href="user_add.asp?id=<%=id%>"'>
					<%end if%>
					<%if userArray1(12,0)="7" or userArray1(12,0)="6" then%>
					<%else%>
						<input type="button" name="button" value=" 删除申请信息 " class="rec_form " onclick='return Delinfo()'>
					<%end if%>
				<%end if%>
			<%end if%>
			</td>
			<td align=right><input type="button" name="button" value=" ［关 闭 ］" class="rec_form" onclick="window.close();opener.location.reload()"></td>
			</tr>
			</table>
		  </td>
		  </tr>		  
		  </table>
	  </td></tr>
   </table>
 </td></tr>
 </table>
 </body>