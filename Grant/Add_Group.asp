<html>
<head>
<%session("id")="D03"%>
<!--#include file=../../login/check_valid.asp-->


	<link rel="stylesheet" type="text/css" href="../include/ams.css">
	<!--#include file=../function/function_pub.asp-->
	<!--#include file=../function/function_db.asp-->
	
	
<title>增加系统组</title>
<%

sub add_group_to_db()
	if  Request.Form.Count>0 then '从提交过来
	    '-----------自动获得用户组编号------------------------
	    StrSQL="select max(WG_ID) from ams.Hwork_group"
		returnStr=connect_db(StrSQL)
		if cstr(returnStr) <> "0"   then  '判断是否oracle出错。
			if cstr(returnStr)= "数据库无记录!" then
				tempStr="GP001"
			else
				call message("系统错误！",cstr(returnStr),0)
				exit sub
			end if
			
		else
			tempStr=session("OraAmsRs").fields(0)
			tempStr1=mid(tempStr,1,2)
			tempStr2=cstr(cint(mid(tempStr,3))+1)  '当前最大值加一
			if tempStr2>"99" then 
			    message "警告：","太多的用户组，请删除部分用户组！",0
			    exit sub
			end if
			if len(tempStr2)=1 then
			     tempStr2="00"&tempStr2
			 elseif len(tempStr2)=2 then
				tempStr2="0"&tempStr2
			end if
			tempStr=tempStr1&(tempStr2)
		end if
		
		
		StrSQL="insert into ams.Hwork_group(WG_ID,WG_NAME,WG_DESC) values('"&tempStr&"','"&Request.Form("Group_Name")&"','"&Request.Form ("Group_Detal")&"')"
		
		returnStr=connect_db(StrSQL)
		if cstr(returnStr) <> "0" and cstr(returnStr)<> "数据库无记录!" then  '判断是否oracle出错。
			call message("系统错误！",cstr(returnStr),0)
			exit sub
		else
		    message "恭喜：","用户组增加成功！",0
		    Response.Write "<SCRIPT LANGUAGE=javascript>"
	        Response.Write "Btm_cancel_onclick()"
			Response.Write "</SCRIPT>"
			runatclient("window.opener.window.location.replace('AuthGroupTop.asp') ")
		    
		end if
	end if 
end sub
%>

<script ID="clientEventHandlersJS" LANGUAGE="javascript">

function fm_add_group_Validator(theForm)
{
 if (theForm.Group_Name.value == "")
  {
    alert("系统组名称不能为空！");
    theForm.Group_Name.focus();
    return (false);
  }
  if (theForm.Group_Name.value.length > 20)
  {
    alert("系统组名称不能超过20个字符！");
    theForm.Group_Name.focus();
    return (false);
  }
  if (theForm.Group_Detal.value.length > 50)
  {
    alert("系统组描述不能超过50个字符！");
    theForm.Group_Detal.focus();
    return (false);
  }
  return (true);
}

function Btm_cancel_onclick() {
  
  window.close()  
}

function Btn_ADD_onclick() {
if(fm_add_group_Validator(fm_add_group)){
  fm_add_group.action="Add_Group.asp "
  fm_add_group.submit()
 }
}


</script>
</head>
<body topmargin="0" leftmargin="0">

<form id="fm_add_group" method="post" target="Add_Group" name="fm_add_group">
    <div align="center">
      <center>
	 <fieldset id="fs_sysgroup" name="fs_sysgroup">
	<legend><font color="#2233FF"><img SRC="../images/maintenance/method.gif" WIDTH="18" HEIGHT="16"> 增加系统组：</font></legend>
	<table border="1" width="400" bordercolorlight="#800080" bordercolordark="#99ccff" cellspacing="3" cellpadding="0" height="180">
      <tr>
	    <td bgcolor="#d1ebfe" align="right" width="102">系统组ID号：</td>
	    <td bgcolor="#d1ebfe" width="290">　</td>
	  </tr>
	  <tr>
	    <td bgcolor="#d1ebfe" align="right" width="102">系统组名称：</td>
	    <td bgcolor="#d1ebfe" width="290">
        
	    <input name="Group_Name" size="54" maxlength="20" style="width: 285; height: 22"></td>
	  </tr>
	  <tr>
	    <td bgcolor="#d1ebfe" align="right" width="102">系统组说明：</td>
	    <td bgcolor="#d1ebfe" width="290"><textarea name="Group_Detal" rows="5" cols="38"></textarea></td>
	  </tr>
	  <tr>
	    <td bgcolor="#d1ebfe" align="right" width="102">　</td>
	    <td bgcolor="#d1ebfe" width="290">
	    <img SRC="../images/button/ADD.gif" name="Btn_ADD" id="Btn_ADD" LANGUAGE="javascript" onclick="return Btn_ADD_onclick()" WIDTH="77" HEIGHT="20">
	    <img SRC="../images/button/cancel.gif" name="Btm_cancel" id="Btm_cancel" LANGUAGE="javascript" onclick="return Btm_cancel_onclick()" WIDTH="77" HEIGHT="20">
	    </td>
	  </tr>
	</table>
    </fieldset>
      </center>
    </div>
    
	</form>
	<script LANGUAGE="javascript">
	<!--
	window.name="Add_Group"
	//-->
	</script>
	<%add_group_to_db%>
</body>
</html>
