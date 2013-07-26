<%
'Response.Write Request.Form("userid")
'Response.End 
%>
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
<script language=javascript>
var oOpener
function openWin(link){
	//alert(link);
	openStr=link;
	var sStyle="left=150,top=50,height=440,width=300,center=1,scroll=0,status=0,directories=0,channelmode=0"
	oOpener=FocusWin(oOpener,openStr,sStyle);
	return false;
}

function uf_UserModify(Ep_ID){//双击某行修改用户资料
<!--
  //alert(Ep_ID)
  if (confirm("确认要修改"+Ep_ID+"用户的资料？")){
	window.location.href="UserModifyMain.asp?sEmp_ID="+Ep_ID;
  }
//-->
}
</script>
</script>
<%userid=Request.Form("userid")
	
	function CountsSQL()
		'统计列数字
	   StrSQL="select count(Ep_ID) from "&Application("DBOwner")&".Grems_Employee"
	 ' CountsSQL=StrSQL
	   set RsCount=server.CreateObject("ADODB.Recordset") 
	   RsCount.Open StrSQL,session("OraAMSCnn"),1,1
	   CountsSQL=cint(RsCount.Fields(0))
	   RsCount.Close 
	   set RsCount=nothing
	end function
	
	
	
'------------打印数组（含有多个Cell）到表格的一行中---------------	
	sub Print_to_table()
		
		for  CountI=0 to CountsSQL()-1
			if isnull(trim(Session("OraAMSRs").fields("EP_WorkGroup"))) then
				disabled=""
				EP_WorkGroup=""
			else
				EP_WorkGroup=right(Session("OraAMSRs").fields("EP_WorkGroup"),len(Session("OraAMSRs").fields("EP_WorkGroup"))-1)
				disabled="disabled"
			end if
			STATION=Session("OraAMSRs").fields("Ep_station")
			STATION=replace(STATION,"A","一/二核")
			STATION=replace(STATION,"D","一核")
			STATION=replace(STATION,"L","二核")
			Response.Write "<tr ondblclick=uf_UserModify('"&Session("OraAMSRs").fields("Ep_ID")&"') language=javascript title=双击修改用户资料>"
			Response.Write "<td><input type=checkbox name=check"&Session("OraAMSRs").fields("Ep_ID")&"  "&disabled&" onclick='return user_info(this.name)'></td>"
			Response.Write "<td>&nbsp;"&Session("OraAMSRs").fields("Ep_ID")&" "&"</td>"&vbcrlf
		   	Response.Write "<td>&nbsp;<a href='UserRight.asp?EP_WORKGROUP="&EP_WORKGROUP&"&name="&Session("OraAMSRs").fields("Ep_Name")&"' onclick='return openWin(this.href)'>"&Session("OraAMSRs").fields("Ep_Name")&"</a> "&"</td>"&vbcrlf
			Response.Write "<td>&nbsp;"&Session("OraAMSRs").fields("EP_DEPSHORTEN")&" "&"</td>"&" "&vbcrlf
			Response.Write "<td>&nbsp;"&Session("OraAMSRs").fields("Ep_depName")&" "&"</td>"&" "&vbcrlf
			Response.Write "<td>&nbsp;"&STATION&"</td>"&" "&vbcrlf
			Response.Write "<td>&nbsp;"&Session("OraAMSRs").fields("EP_TEL")&" "&"</td>"&" "&vbcrlf
			Response.Write "<td>&nbsp;"&EP_WorkGroup&" "&"</td>"&" "&vbcrlf
			Response.Write "<td><input type=button value='密码复位' name=topwd"&Session("OraAMSRs").fields("Ep_ID")&" onclick=javascript:touserpwd('"&Session("OraAMSRs").fields("Ep_ID")&"') style='CURSOR: hand;'  style='border:2px solid #393;background-color:white;color:#393;font-size:13px;height:20px;font-weight:bold'></td>"&" "&vbcrlf
		   	Response.Write "</tr>"&vbcrlf

			session("OraAMSRs").moveNext	
	    Next
	end sub 

sub GetUserInfo(sMod)
	dim returnStr
		if sMod="Id" then
			eSQL="order by Ep_ID desc"
		elseif sMod="User" then
			eSQL="order by Ep_Name desc"
		elseif sMod="Group" then
			eSQL="order by EP_WorkGroup desc"
		end if
		StrSQL="select Ep_ID,Ep_Name,EP_WorkGroup,EP_DEPSHORTEN,Ep_depName,EP_TEL,EP_STATION from "&Application("DBOwner")&".Grems_Employee "&eSQL&""
		returnStr=connect_db(StrSQL)
		if cstr(returnStr) <> "0" and  returnStr<> "数据库无记录!" then  '判断是否oracle出错。
			message "系统错误！",cstr(returnStr),0
			exit sub
		else
			if  returnStr= "数据库无记录!"then
			    
			else
			   call Print_to_table()
			end if
		end if
end sub

%>

</head>
<script language=javascript>
function selectType(sMod){
	document.userForm.action="userAdd.asp";
	document.userForm.selectMod.value=sMod;   
	document.userForm.submit();  
}


function touserpwd(ep_id){
	var th=confirm("是否要复位用户 "+ep_id+" 的密码？")
		if(th){
			window.location.href="touserpwd.asp?ep_id="+ep_id+""  
			}
		else{
			return false;
			}
}

function submitform(sMod){
	if(sMod=="DellAll"){
	var th=confirm("是否要删除所有不在组中的用户？")
		if(th){
			document.userForm.action="User_function.asp";
			document.userForm.selectMod.value=sMod;
			document.userForm.submit();
			}
		else{
			return false;
			}
	}
	else if(sMod=="Dell"){
	var dellinfo=document.userForm.del_info.value;
		if(dellinfo==""){
			alert("请选择要删除的用户信息!");
			return false;
		}
		else{
			var re=/check/g;
			dellinfo=dellinfo.replace(re,"")   
			dellinfo=dellinfo.substring(0,dellinfo.length-1)
			var th=confirm("是否要删除用户\n"+dellinfo+"")
			if(th){
				document.userForm.action="User_function.asp";
				document.userForm.selectMod.value=sMod;
				document.userForm.submit();
				}
			else{
				return false;
				}
		}
	}
	else
	{
		document.userForm.action="User_function.asp";
		document.userForm.selectMod.value=sMod;
		document.userForm.submit();
	}     
}

function user_info(obj){
	var info=document.userForm.del_info.value;
	obj=obj+","
	if(info.indexOf(obj)==-1){
		info=info+obj;
	}
	else{
		var nameL=obj.length+1
		var sL=info.indexOf(obj);
		var L=info.length;
		var Ninfo=info.substring(0,sL)+info.substring(sL+nameL-1,L);
		//alert(Ninfo);
		info=Ninfo;
	}
	document.userForm.del_info.value=info;  
}
</script>
<body>
<form name=userForm method=post>
<input type=hidden name=selectMod>
<table border="0" width="100%" >
  <tr><td align=right>
  <input type=button value="添加 >>"  name="Adduser" onclick='javascript:return submitform("Add")' style='CURSOR: hand;' LANGUAGE="javascript"  style="border:2px solid #393;background-color:white;color:#393;font-size:13px;height:20px;font-weight:bold">
  <input type=button value="全删"  name="Delall" onclick='javascript:return submitform("DellAll")' style='CURSOR: hand;' LANGUAGE="javascript" style="border:2px solid #393;background-color:white;color:#393;font-size:13px;height:20px;font-weight:bold">
  <input type=button value="删除 >>"  name="Delleach" onclick='javascript:return submitform("Dell")' style='CURSOR: hand;' LANGUAGE="javascript" style="border:2px solid #393;background-color:white;color:#393;font-size:13px;height:20px;font-weight:bold">
  
  </td></tr>
  <tr>
    <td width="30%" colspan="2">
    <fieldset id="fs_sysgroup" name="fs_sysgroup">
	<legend><img SRC="../images/collection.gif" WIDTH="16"> 所有用户</legend>
      <table name="TB_for_Write" ID="TB_for_Write" border="1" width="100%" bordercolorlight="#444444" bordercolordark="#339933">
        <tr style="color:white">
          <td bgcolor="#339933">&nbsp;</td>
          <td align="center" bgcolor="#339933" height="16">
            <input type=button value="登录用户帐号"  name="selectId" onclick='javascript:selectType("Id")' style='CURSOR: hand;'  style="border:0px solid white;background-color:#393;color:white;font-size:12px;height:15px;width:90px">
          </td>
          <td align="center" bgcolor="#339933" height="16">
           <input type=button value="用户姓名"  name="selectUser" onclick='javascript:selectType("User")' style='CURSOR: hand;'  style="border:0px solid white;background-color:#393;color:white;font-size:12px;height:15px;width:70px">
          </td>
          <td align="center" bgcolor="#339933" height="16">所在部门ID</td>
          <td align="center" bgcolor="#339933" height="16">所在部门名称</td>
          <td align="center" bgcolor="#339933" height="16">所属电站</td>
          <td align="center" bgcolor="#339933" height="16">电话地点</td>
          <td align="center" bgcolor="#339933" height="16">
          <input type=button value="用户所在组"  name="selectGroup" onclick='javascript:selectType("Group")' style='CURSOR: hand;'  style="border:0px solid white;background-color:#393;color:white;font-size:12px;height:15px;width:90px">
          </td>
          <td align="center" bgcolor="#339933" height="16">&nbsp;</td>
        </tr>
        <%
			tempStr=trim(Request.Form("selectMod"))
			GetUserInfo(tempStr)
		%>
		<input type=hidden name=del_info size=50><input type=hidden value=<%=userid%> name=userid>
      </table>
    </td>
  </tr>
  
</table>
</form>
</body>

</html>
