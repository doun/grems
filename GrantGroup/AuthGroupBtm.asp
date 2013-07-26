
<%Response.Expires=0%>
<html>
<style>
TABLE
{
    FONT-SIZE: 12px;
    WIDTH: 100%;
    BORDER-COLLAPSE: collapse
}
</style>
<head>
<!--#include file="check.asp"-->


	<meta http-equiv="Content-Type" content="text/html; charset=gb2312">

<!--#include file=function/function_pub.asp-->
<!--#include file=function/function_db.asp-->
<!--#include file=function/function_jsp.asp-->
<title>用户</title>
<%

	function CountsSQL(Group_ID)
		'统计列数字---------不知为何object.RecordCount显示为-1 
	   StrSQL="select count(Ep_ID) from "&Application("DBOwner")&".Grems_Employee where EP_WorkGroup like '%"&Ucase(Group_ID)&"%'"
	 ' CountsSQL=StrSQL
	   set RsCount=server.CreateObject("ADODB.Recordset") 
	   RsCount.Open StrSQL,session("OraAMSCnn"),1,1
	   CountsSQL=cint(RsCount.Fields(0))
	   RsCount.Close 
	   set RsCount=nothing
	end function
	
	
	
'------------打印数组（含有多个Cell）到表格的一行中---------------	
	sub Print_to_table(Group_ID)
		
		for  CountI=0 to CountsSQL(Group_ID)-1
			EP_WORKGROUP=right(Session("OraAMSRs").fields("EP_WorkGroup"),len(Session("OraAMSRs").fields("EP_WorkGroup"))-1)
			Response.Write "<tr>"
			Response.Write "<td>&nbsp;"&Session("OraAMSRs").fields("Ep_ID")&" "&"</td>"&vbcrlf
		   	Response.Write "<td>&nbsp;<a href='UserRight.asp?EP_WORKGROUP="&EP_WORKGROUP&"&name="&Session("OraAMSRs").fields("Ep_Name")&"' onclick='return openWin(this.href)'>"&Session("OraAMSRs").fields("Ep_Name")&" "&"</a></td>"&vbcrlf
			Response.Write "<td>&nbsp;"&Session("OraAMSRs").fields("Ep_depName")&" "&"</td>"&" "&vbcrlf
			Response.Write "<td>&nbsp;"&Session("OraAMSRs").fields("EP_TEL")&" "&"</td>"&" "&vbcrlf
			Response.Write "<td>&nbsp;"&EP_WORKGROUP&" "&"</td>"&" "&vbcrlf
		   	Response.Write "</tr>"&vbcrlf

			session("OraAMSRs").moveNext	
	    Next
	end sub 

sub GetUserInfo(Group_ID)
	dim returnStr
	
		StrSQL="select Ep_ID,Ep_Name,EP_WorkGroup,Ep_depName,EP_TEL from "&Application("DBOwner")&".Grems_Employee where EP_WorkGroup like '%"&Ucase(Group_ID)&"%'"
		returnStr=connect_db(StrSQL)
		if cstr(returnStr) <> "0" and  returnStr<> "数据库无记录!" then  '判断是否oracle出错。
			message "系统错误！",cstr(returnStr),0
			exit sub
		else
			if  returnStr= "数据库无记录!"then
			    
			else
			   call Print_to_table(Group_ID)
			end if
		end if
end sub

%>
<script ID="clientEventHandlersJS" LANGUAGE="javascript">
<!--
var oOpener
function ModiUser_onclick(WG_ID) {
 openStr="groupUser.asp?WG_ID="+WG_ID ;
 var sStyle="left=150,top=50,height=410,width=450,center=1,scroll=0,status=0,directories=0,channelmode=0"
 oOpener=FocusWin(oOpener,openStr,sStyle);
}

function openWin(link){
	//alert(link);
	openStr=link;
	var sStyle="left=150,top=50,height=440,width=300,center=1,scroll=0,status=0,directories=0,channelmode=0"
	oOpener=FocusWin(oOpener,openStr,sStyle);
	return false;
}
//-->
</script>
</head>

<body>

<table border="0" width="100%" >
  <tr>
    <td width="33%" colspan="2">
    <fieldset id="fs_sysgroup" name="fs_sysgroup">
	<legend><img SRC="../images/collection.gif" WIDTH="16"> 当前组用户</legend>
      <table name="TB_for_Write" ID="TB_for_Write" border="1" width="100%" bordercolorlight="#444444" bordercolordark="#339933">
        <tr style="color:white">
          <td width="16%" bordercolorlight="#800080" bordercolordark="#99CCFF" align="center" bgcolor="#339933" height="15">登录用户帐号</td>
          <td width="16%" align="center" bgcolor="#339933" height="16">用户姓名</td>
          <td width="16%" align="center" bgcolor="#339933" height="16">所在部门</td>
          <td width="20%" align="center" bgcolor="#339933" height="16">用户信息:电话地点</td>
          <td width="28%" align="center" bgcolor="#339933" height="16">用户所在组</td>
        </tr>
        <%
	tempStr=trim(Request.Form("WG_ID"))
	'Response.Write tempStr &"<br>"
	'Response.Write Request.Form("userid")
	if tempStr="" then tempStr="WG001"
	GetUserInfo(tempStr)
		%>
      </table>
    </td>
  </tr>
  <tr>
    <td width="48%" align="right">
    <input type=button value="修改组用户" id="ModiUser" name="ModiUser" style='CURSOR: hand;' LANGUAGE="javascript" onclick="ModiUser_onclick('<%=request("WG_ID")%>')" style="border:2px solid #393;background-color:white;color:#393;font-size:13px;height:20px;font-weight:bold">
  </td>
  </tr>
</table>
</body>

</html>
