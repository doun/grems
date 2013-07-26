<%
userid=Request.Form("userid")
'Response.Write userid
%>
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
	<meta http-equiv="Content-Type" content="text/html; charset=gb2312">


<!--#include file="check.asp"-->



<!--#include file=function/function_pub.asp-->
<!--#include file=function/function_db.asp-->
<!--#include file=function/function_jsp.asp-->


<title>系统组</title>
<%
sub check_for_del()

if len(Request("DEL_ID"))>=5 then '保证点击DEL键而来
		StrSQL="select * from "&Application("DBOwner")&".Grems_Employee where EP_WorkGroup like '%"&Request("DEL_ID")&"%' order by ep_id"
		returnStr=connect_db(StrSQL)
		if cstr(returnStr) <> "0" and  returnStr<> "数据库无记录!" then  '判断是否oracle出错。
			message "系统错误！",cstr(returnStr),0
			exit sub
		else
			if  returnStr= "数据库无记录!" then
			StrSQL="delete from "&Application("DBOwner")&".Grems_Work_Group where WG_ID='"&Request("DEL_ID")&"'"
			returnStr=connect_db(StrSQL)
				if cstr(returnStr) <> "0" and  returnStr<> "数据库无记录!" then  '判断是否oracle出错。
					message "系统错误！",cstr(returnStr),0
					exit sub
				else
				    message "恭喜：","已经成功删除！",0
				end if
			else
				message "注意：","此用户组含有用户，不能删除！",0
			end if
     end if
end if
end sub

	function CountsSQL()
		'统计列数字---------不知为何object.RecordCount显示为-1 
		StrSQL="select count(WG_ID) from "&Application("DBOwner")&".Grems_Work_Group order by wg_id"
	    set RsCount=server.CreateObject("ADODB.Recordset") 
	    RsCount.Open StrSQL,session("OraAMSCnn"),1,1
	    CountsSQL=cint(RsCount.Fields(0))
	    RsCount.Close 
	    set RsCount=nothing
	end function
	
	
'------------打印数组（含有多个Cell）到表格的一行中---------------	
	
	sub Print_to_table(userid)
	    RunAtClient("ClickedRow='"&Session("OraAMSRs").fields("WG_ID")&"'")
	    'message "aa","ClickedRow='"&Session("OraAMSRs").fields("WG_ID")&"'",0
	 
	    for  CountI=0 to CountsSQL()-1
			'原来用的串：OpenStr1="'AuthGroupBtm.asp?WG_ID="&Session("OraAMSRs").fields("WG_ID")&"','bottom',null,false"
			
			'通过一空页面传到下一个页面，以便刷新。
			'OpenStr="'win_empty.asp?URL=AuthGroupBtm.asp?WG_ID="&Session("OraAMSRs").fields("WG_ID")&"','bottom',null,false"
			
			WG_ID=Session("OraAMSRs").fields("WG_ID")
			tempStr="<TR style='CURSOR: hand;' id="&Session("OraAMSRs").fields("WG_ID")&" LANGUAGE='javascript' onclick=""TB_for_Write.rows(ClickedRow).bgColor='';this.bgColor='#FFAADD';ClickedRow=this.id;checkBottom('"&WG_ID&"')"">"&vbcrlf
			Response.Write "<td>"&LinkStr&"</td>"&vbcrlf		'点击改变颜色
			Response.Write tempStr
			Response.Write "<td>&nbsp;"&Session("OraAMSRs").fields("WG_ID")&" "&"</td>"&vbcrlf
		   	Response.Write "<td>&nbsp;"&Session("OraAMSRs").fields("WG_Name")&" "&"</td>"&vbcrlf
			Response.Write "<td>&nbsp;"&Session("OraAMSRs").fields("WG_Desc")&" "&"</td>"&" "&vbcrlf
		   	Response.Write "</tr>"&vbcrlf
		   	session("OraAMSRs").moveNext	
	    Next
	   
	  
	end sub 
	
'---------获得当前所有工作组的名称并通过列表框显示---------
sub get_Group(userid)          
   	dim returnStr
		'check_valid
		StrSQL="select WG_ID,WG_NAME,WG_RIGHT,WG_DESC from "&Application("DBOwner")&".Grems_Work_Group order by wg_id"
		returnStr=connect_db(StrSQL)
		if cstr(returnStr) <> "0" then  '判断是否oracle出错。
			if cstr(returnStr)<>"数据库无记录!" then
				Response.Write "系统错误！"&cstr(returnStr)
			end if
			exit sub
		else
			Print_to_table(userid)
		end if
end sub
%>
<script ID="clientEventHandlersJS" LANGUAGE="javascript">
var oOpener
function Btn_Add_onclick() {
    //alert(ClickedRow)
    openStr="Add_Group.asp?WG_ID="+ClickedRow
    var sStyle="left=120,top=150,height=200,width=400,center=1,scroll=0,status=0,directories=0,channelmode=0"
	oOpener=FocusWin(oOpener,openStr,sStyle)	
}


function checkBottom(WG_ID){
	//alert(WG_ID)
	var sID=parent.parent.parent.document.all['__USER_ROLE'].value
	//alert(sID)
	fm_del_group.innerHTML="<input type=hidden name='userid' value='"+sID+"'><input type=hidden name='WG_ID' value='"+WG_ID+"'>"
	fm_del_group.target="bottom" 
	fm_del_group.action="AuthGroupBtm.asp"
	fm_del_group.submit();
}

function Btn_Del_onclick() {
  //TB_for_Write.deleteRow(ClickedRow) 
  if(confirm("确定删除当前组吗:"+ClickedRow+"？")){
	 var sID=parent.parent.parent.document.all['__USER_ROLE'].value
	 //alert(sID)
	 fm_del_group.innerHTML="<input type=hidden name='userid' value='"+sID+"'>"
     
     TempStr="AuthGroupTop.asp?Del_ID="+ClickedRow
     //alert(TempStr)
     fm_del_group.action=TempStr
     fm_del_group.target="top" 
     fm_del_group.submit() 
  }
}
var oOpener1
function Btn_Modi_onclick() {
	openStr="Modi_group.asp?WG_ID="+ClickedRow
	//popup = window.showModalDialog(tempStr,"s",'dialogWidth:26;dialogHeight:16.5;dialogLeft:100;dialogTop:180;center:0;scroll:0;status:0 ');
	  var sStyle="left=120,top=150,height=200,width=400,center=1,scroll=0,status=0,directories=0,channelmode=0"
	oOpener1=FocusWin(oOpener1,openStr,sStyle)	
}

function Btn_Modi_auth_onclick() {
	//tempStr="Authgroup.asp"
	//popup = window.open("win_empty.asp?URL=AuthGroupList.asp","main",null,false);
	var sID=parent.parent.parent.document.all['__USER_ROLE'].value
	fm_del_group.innerHTML="<input type=hidden name='userid' value='"+sID+"'>"
	document.fm_del_group.target="main" 
	document.fm_del_group.action="AuthGroupList.asp";  
	document.fm_del_group.submit();
	
}


</script>
</head>
<script LANGUAGE="javascript">
	var ClickedRow; //保存原来更改的行的ID值
	ClickedRow="";
	
</script>

<body leftmargin="0" topmargin="0" language="javascript" onload="window.scrollTo(0,25);">
	<%call check_for_del()%>
	
<%
'server.execute("../toolbar.asp") %>
		
  
  <table border="0" width="100%" cellspacing="1" cellpadding="0">
    
    <tr>
      <td width="100%">
      <fieldset id="fs_sysgroup" name="fs_sysgroup">
		<legend><img SRC="../images/behavior.gif" WIDTH="16"> 系统组成员</legend>
		  <table name="TB_for_Write" ID="TB_for_Write" border="1" cellspacing="0" cellpadding="1" width="100%"  bordercolorlight="#444444" bordercolordark="#339933" >
          <tr style="color:white">
            <td width="12%" height="16" bgcolor="#339933">&nbsp;系统组编码</td>
            <td width="14%" height="16" bgcolor="#339933">&nbsp;系统组名称</td>
            <td width="49%" height="16" bgcolor="#339933">&nbsp;系统组描述</td>
          </tr>
          <%call get_Group(userid)%>
        </table>
       </fieldset>
      </td>
    </tr>
    <tr>
      <td width="100%" align="right">
      <input type=button name="Btn_Add" id="Btn_Add" value=">> 增加" style='CURSOR: hand;' LANGUAGE="javascript" onclick="return Btn_Add_onclick()" style="border:2px solid #393;background-color:white;color:#393;font-size:13px;height:20px;font-weight:bold">
      <input type=button name="Btn_Del" id="Btn_Del" value=">> 删除" style='CURSOR: hand;' LANGUAGE="javascript" onclick="return Btn_Del_onclick()" style="border:2px solid #393;background-color:white;color:#393;font-size:13px;height:20px;font-weight:bold">
      <input type=button name="Btn_Modi" id="Btn_Modi" value="修改组名称" style='CURSOR: hand;' LANGUAGE="javascript" onclick="return Btn_Modi_onclick()" style="border:2px solid #393;background-color:white;color:#393;font-size:13px;height:20px;font-weight:bold">
      <input type=button name="Btn_Modi_auth" id="Btn_Modi_auth" value="修改组权限" style='CURSOR: hand;' LANGUAGE="javascript" onclick="return Btn_Modi_auth_onclick()" style="border:2px solid #393;background-color:white;color:#393;font-size:13px;height:20px;font-weight:bold">
      </td>
    </tr>
  </table>
<form id="fm_del_group" style="display:none;" name="fm_Del_group" method="post" target="top">
</form>
</body>



</html>
