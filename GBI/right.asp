 <!--#include file="function.asp"-->
<%
call checksession()
userid=split(session("userinfo"),"/@")(0)
username=split(session("userinfo"),"/@")(1)
dept_id=split(session("userinfo"),"/@")(2)
dept_name=split(session("userinfo"),"/@")(3)
leader=split(session("userinfo"),"/@")(4)

sort=trim(Request("sort"))
if sort="1" then
	title="已经批准项目"
elseif sort="2" then
	title="已关闭项目"
else
	if dept_id="1" or dept_id="2" then
		title="待审核项目"
	elseif leader="1" then
		title=""&dept_name&" -- 部门项目"
	else
		title="申请的项目"
	end if
end if

sub list()
if sort="1" then
	if dept_id="1" then
		sql="select t1.ITEM_ID,t1.ITEM_NAME,t1.ITEM_APPLY_DATE,t1.ITEM_ACCEPT_DATE,t2.gbi_type_name from "&Application("DBOwner")&".GBI_DOCUMENT t1,"&Application("DBOwner")&".GBI_TYPE t2 where t1.item_type_id=t2.bgi_type_id (+)  and  t1.item_type_id>='3' order by t1.ITEM_APPLY_DATE desc"
		sqlcount="select count(t1.ITEM_ID) from "&Application("DBOwner")&".GBI_DOCUMENT t1,"&Application("DBOwner")&".GBI_TYPE t2 where t1.item_type_id=t2.bgi_type_id (+)  and  item_type_id>='3' order by t1.id desc"
	elseif dept_id="2" then
		sql="select t1.ITEM_ID,t1.ITEM_NAME,t1.ITEM_APPLY_DATE,t1.ITEM_ACCEPT_DATE,t2.gbi_type_name from "&Application("DBOwner")&".GBI_DOCUMENT t1,"&Application("DBOwner")&".GBI_TYPE t2 where t1.item_type_id=t2.bgi_type_id (+)  and  t1.item_type_id>='6' order by t1.ITEM_APPLY_DATE desc"
		sqlcount="select count(t1.ITEM_ID) from "&Application("DBOwner")&".GBI_DOCUMENT t1,"&Application("DBOwner")&".GBI_TYPE t2 where t1.item_type_id=t2.bgi_type_id (+)  and  item_type_id>='6' order by t1.id desc"
	elseif leader="1" then
		sql="select t1.ITEM_ID,t1.ITEM_NAME,t1.ITEM_APPLY_DATE,t1.ITEM_ACCEPT_DATE,t2.gbi_type_name from "&Application("DBOwner")&".GBI_DOCUMENT t1,"&Application("DBOwner")&".GBI_TYPE t2 where t1.item_type_id=t2.bgi_type_id (+) and t1.item_apply_dept='"&dept_id&"' and t1.item_type_id='6' order by t1.ITEM_APPLY_DATE desc"
		sqlcount="select count(t1.ITEM_ID) from "&Application("DBOwner")&".GBI_DOCUMENT t1,"&Application("DBOwner")&".GBI_TYPE t2 where t1.item_type_id=t2.bgi_type_id (+)  and t1.item_apply_dept='"&dept_id&"'and t1.item_type_id='6' order by t1.id desc"
	else
		sql="select t1.ITEM_ID,t1.ITEM_NAME,t1.ITEM_APPLY_DATE,t1.ITEM_ACCEPT_DATE,t2.gbi_type_name from "&Application("DBOwner")&".GBI_DOCUMENT t1,"&Application("DBOwner")&".GBI_TYPE t2 where t1.item_type_id=t2.bgi_type_id (+) and t1.item_apply_id='"&userid&"' and  item_type_id='6' order by t1.ITEM_APPLY_DATE desc"
		sqlcount="select count(t1.ITEM_ID) from "&Application("DBOwner")&".GBI_DOCUMENT t1,"&Application("DBOwner")&".GBI_TYPE t2 where t1.item_type_id=t2.bgi_type_id (+) and t1.item_apply_id='"&userid&"' and  item_type_id='6' order by t1.id desc"
	end if
elseif sort="2" then
	if leader="1" then
		sql="select t1.ITEM_ID,t1.ITEM_NAME,t1.ITEM_APPLY_DATE,t1.ITEM_ACCEPT_DATE,t2.gbi_type_name from "&Application("DBOwner")&".GBI_DOCUMENT t1,"&Application("DBOwner")&".GBI_TYPE t2 where t1.item_type_id=t2.bgi_type_id (+) and t1.item_apply_dept='"&dept_id&"' and t1.item_type_id='7' order by t1.ITEM_APPLY_DATE desc"
		sqlcount="select count(t1.ITEM_ID) from "&Application("DBOwner")&".GBI_DOCUMENT t1,"&Application("DBOwner")&".GBI_TYPE t2 where t1.item_type_id=t2.bgi_type_id (+)  and t1.item_apply_dept='"&dept_id&"'and t1.item_type_id='7' order by t1.id desc"
	else
	sql="select t1.ITEM_ID,t1.ITEM_NAME,t1.ITEM_APPLY_DATE,t1.ITEM_ACCEPT_DATE,t2.gbi_type_name from "&Application("DBOwner")&".GBI_DOCUMENT t1,"&Application("DBOwner")&".GBI_TYPE t2 where t1.item_type_id=t2.bgi_type_id (+) and t1.item_apply_id='"&userid&"' and  item_type_id='7' order by t1.ITEM_APPLY_DATE desc"
	sqlcount="select count(t1.ITEM_ID) from "&Application("DBOwner")&".GBI_DOCUMENT t1,"&Application("DBOwner")&".GBI_TYPE t2 where t1.item_type_id=t2.bgi_type_id (+) and t1.item_apply_id='"&userid&"' and  item_type_id='7' order by t1.id desc"
	end if
else
	if dept_id="1" then
		sql="select t1.ITEM_ID,t1.ITEM_NAME,t1.ITEM_APPLY_DATE,t1.ITEM_ACCEPT_DATE,t2.gbi_type_name from "&Application("DBOwner")&".GBI_DOCUMENT t1,"&Application("DBOwner")&".GBI_TYPE t2 where t1.item_type_id=t2.bgi_type_id (+) and t1.item_type_id<'3' order by t1.ITEM_APPLY_DATE desc"
		sqlcount="select count(t1.ITEM_ID) from "&Application("DBOwner")&".GBI_DOCUMENT t1,"&Application("DBOwner")&".GBI_TYPE t2 where t1.item_type_id=t2.bgi_type_id (+)  and t1.item_type_id<'3' order by t1.id desc"
	elseif dept_id="2" then
		sql="select t1.ITEM_ID,t1.ITEM_NAME,t1.ITEM_APPLY_DATE,t1.ITEM_ACCEPT_DATE,t2.gbi_type_name from "&Application("DBOwner")&".GBI_DOCUMENT t1,"&Application("DBOwner")&".GBI_TYPE t2 where t1.item_type_id=t2.bgi_type_id (+) and t1.item_type_id='3'  order by t1.ITEM_APPLY_DATE desc"
		sqlcount="select count(t1.ITEM_ID) from "&Application("DBOwner")&".GBI_DOCUMENT t1,"&Application("DBOwner")&".GBI_TYPE t2 where t1.item_type_id=t2.bgi_type_id (+)  and t1.item_type_id='3' order by t1.id desc"
	elseif leader="1" then
		sql="select t1.ITEM_ID,t1.ITEM_NAME,t1.ITEM_APPLY_DATE,t1.ITEM_ACCEPT_DATE,t2.gbi_type_name from "&Application("DBOwner")&".GBI_DOCUMENT t1,"&Application("DBOwner")&".GBI_TYPE t2 where t1.item_type_id=t2.bgi_type_id (+) and t1.item_apply_dept='"&dept_id&"'  order by t1.ITEM_APPLY_DATE desc"
		sqlcount="select count(t1.ITEM_ID) from "&Application("DBOwner")&".GBI_DOCUMENT t1,"&Application("DBOwner")&".GBI_TYPE t2 where t1.item_type_id=t2.bgi_type_id (+)  and t1.item_apply_dept='"&dept_id&"' order by t1.id desc"
	else
		sql="select t1.ITEM_ID,t1.ITEM_NAME,t1.ITEM_APPLY_DATE,t1.ITEM_ACCEPT_DATE,t2.gbi_type_name from "&Application("DBOwner")&".GBI_DOCUMENT t1,"&Application("DBOwner")&".GBI_TYPE t2 where t1.item_type_id=t2.bgi_type_id (+) and t1.item_apply_id='"&userid&"'  order by t1.ITEM_APPLY_DATE desc"
		sqlcount="select count(t1.ITEM_ID) from "&Application("DBOwner")&".GBI_DOCUMENT t1,"&Application("DBOwner")&".GBI_TYPE t2 where t1.item_type_id=t2.bgi_type_id (+) and t1.item_apply_id='"&userid&"' order by t1.id desc"
	end if
end if
call dbQuery(sql,sqlcount,userArray,userRows) 
if userRows<>-1 then
	Response.Write "<tr align=center bgcolor=#aaddff><td height=25 width=12% >申请单号</td><td width=31% >项目名称</td><td width=20% >申请时间</td><td width=20% >接单时间</td><td width=20% >状态</td></tr>"
	for i=0 to ubound(userArray,2)
		if userArray(4,i)="" or isnull(userArray(4,i)) then
			typeinfo="正在申请"
		else
			typeinfo=userArray(4,i)
		end if
		if isdate(userArray(2,i)) then
			sdate=FormatDateTime(userArray(2,i),0)
		end if
		if isdate(userArray(3,i)) then
			adate=FormatDateTime(userArray(3,i),0)
		end if
		Response.Write "<tr bgcolor=#ffffff onmouseover=javascript:this.bgColor='#ddf0ff'  onmouseout=javascript:this.bgColor='#ffffff' onclick=Btn_Add_onclick('item_info.asp?id="&userArray(0,i)&"','500','600')  style='cursor:hand' id='"&userArray(0,i)&"'><td align=center>"&userArray(0,i)&"</td><td>&nbsp;"&userArray(1,i)&"</td><td align=center>"&sdate&"</td><td align=center>&nbsp;"&adate&"&nbsp;</td><td>&nbsp;<font color=red>"&typeinfo&"</td></tr>"
	next
else
		Response.Write "<tr align=center ><td align=center height=30><font color=red>没有任何项目信息</font></td></tr>"

end if
end sub
%>
<link type="text/css" rel="stylesheet" href="css.css">

<body bgcolor=#aaddff leftMargin=0 topMargin=0 >
<table border=0 width=100%>
<tr><td height=5></td></tr>
<tr><td>
  <table width="99%" border="1" align="center" cellpadding="5" cellspacing="0" bordercolorlight="#A5C8F1" bordercolordark="#ffffff" bgcolor=#ddf0ff>
	  <tr><td >
	   	  <table width="100%" border="1" align="center" cellpadding="2" cellspacing="0" bordercolorlight="#A5C8F1" bordercolordark="#ffffff">
		  <tr>
		  <td colspan=5 id=t11>&nbsp;&nbsp;&nbsp;<font color=blue><%=title%><font face=webdings>6</font></font></td>
		  </tr>
		  <%call list()%>
		  </table>
	  </td></tr>
   </table>
 </td></tr>
 </table>
 </body>
