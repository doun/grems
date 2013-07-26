<%@ Language=VBScript %>
<%Response.Expires=0%>

<html>
<head>
<%session("id")="D03"%>
<!--#include file=../../login/check_valid.asp-->

	<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
	<link rel="stylesheet" type="text/css" href="../include/ams.css">
	<!--#include file=../function/function_pub.asp-->
	<!--#include file=../function/function_db.asp-->
<title></title>
</head>

<%
sub Write_to_table(sModel)
	dim upModuleID,theSame,first,last,up_RightCode,up_ModuleName
	theSame=false
	first=true
	last=false
	
	strSQL="select Rc_classID,Rc_className,RC_ModuleID,RC_ModuleID||'.'||RC_ModuleName as RC_ModuleName ,RC_RightCode from ams.HRightConstant where Rc_classID='"&sModel&"' order by Rc_classID,RC_ModuleID,RC_RightCode"
	returnStr=connect_db(StrSQL)
	if cstr(returnStr) <> "0" then		'判断是否oracle出错。
		message "系统错误！",cstr(returnStr),0
		exit sub
	else
			
	'--------------列表显示所有子模块-----------------------
	upModuleID=""	
	up_RightCode=""						'保存上一次的数据
	up_ModuleName=""					'保存上一次的数据
	
	for ii=0 to Session("OraAMSRs").RecordCount-1 
		if upModuleID<>cstr(Session("OraAMSRs").fields("RC_ModuleID")) then
			if theSame then 
				last="&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp"
			else
				last=""
				
			end if
			theSame=false
			first=true
			
		else							'相同，上一个记录是它的上一级
			theSame=true
			
		end if
		
	    if up_ModuleName<>"" then		'第一次轮空
			if theSame then		'和上一个记录一样,证明是它的子项或子项的同级
			'Response.Write "theSame or last"&theSame&"||"&last
				i=i+1
				if first then			'它的子项的父项
					
					first=false
					tempStr="<TR><td id="&up_RightCode&" width='20%' border=1><label for='"&up_RightCode&"'><input type=checkbox name="&up_RightCode&" ID="&up_RightCode&" value='ON'disabled>"
				else
					if instr(" "&Request("Group_Right"),up_RightCode)>0 then
						tempStr="<TR><td id="&up_RightCode&" width='20%' border=1>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp<label for='"&_
								up_RightCode&"'><input type=checkbox name="&up_RightCode&" ID="&up_RightCode&" value='ON'checked>" 
					else
						tempStr="<TR><td id="&up_RightCode&" width='20%' border=1>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp<label for='"&_
								up_RightCode&"'><input type=checkbox name="&up_RightCode&" ID="&up_RightCode&" value='ON'>"
					end if
					
				end if
			else
					
					if instr(" "&Request("Group_Right"),up_RightCode)>0 then
						tempStr="<TR><td id="&up_RightCode&" width='20%' border=1>"&last&"<label for='"&_
								up_RightCode&"'><input type=checkbox name="&up_RightCode&" ID="&up_RightCode&" value='ON'checked>"    
					else
						tempStr="<TR><td id="&up_RightCode&" width='20%' border=1>"&last&"<label for='"&_
								up_RightCode&"'><input type=checkbox name="&up_RightCode&" ID="&up_RightCode&" value='ON'>"    
					end if 

			end if
	
			Response.Write tempStr&up_ModuleName&"</label></TD></TR>"
		end if
		up_RightCode=Session("OraAMSRs").fields("RC_RightCode") '保存上一次的数据
		up_ModuleName=Session("OraAMSRs").fields("RC_ModuleName")'保存上一次的数据
		upModuleID=cstr(Session("OraAMSRs").fields("RC_ModuleID"))
		Session("OraAMSRs").MoveNext
		
	next
	'最后记录---------------------------------------------
		
			if theSame then 
				last="&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp"
			else
				last=""
				
			end if
			theSame=false
			first=true
			
		
		
			if theSame then		'和上一个记录一样,证明是它的子项或子项的同级
			'Response.Write "theSame or last"&theSame&"||"&last
				i=i+1
				if first then			'它的子项的父项
					
					first=false
					tempStr="<TR><td id="&up_RightCode&" width='20%' border=1><label for='"&up_RightCode&"'><input type=checkbox name="&up_RightCode&" ID="&up_RightCode&" value='ON'disabled>"
				else
					if instr(" "&Request("Group_Right"),up_RightCode)>0 then
						tempStr="<TR><td id="&up_RightCode&" width='20%' border=1>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp<label for='"&_
								up_RightCode&"'><input type=checkbox name="&up_RightCode&" ID="&up_RightCode&" value='ON'checked>" 
					else
						tempStr="<TR><td id="&up_RightCode&" width='20%' border=1>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp<label for='"&_
								up_RightCode&"'><input type=checkbox name="&up_RightCode&" ID="&up_RightCode&" value='ON'>"
					end if
					
				end if
			else
					
					if instr(" "&Request("Group_Right"),up_RightCode)>0 then
						tempStr="<TR><td id="&up_RightCode&" width='20%' border=1>"&last&"<label for='"&_
								up_RightCode&"'><input type=checkbox name="&up_RightCode&" ID="&up_RightCode&" value='ON'checked>"    
					else
						tempStr="<TR><td id="&up_RightCode&" width='20%' border=1>"&last&"<label for='"&_
								up_RightCode&"'><input type=checkbox name="&up_RightCode&" ID="&up_RightCode&" value='ON'>"    
					end if 

			end if
	
			Response.Write tempStr&up_ModuleName&"</label></TD></TR>"
	'---------------------------------------------------------------------------
	end if
end sub
%>
<SCRIPT LANGUAGE=javascript>
<!--
function select_all(sModel,trueOrFalse){
	for(i = 0; i < document.all.length; i++){
		
		if(document.all(i).tagName=="INPUT"){
			if(document.all(i).id.substr(0,1)==sModel){
			eval("fm_GROUPinfo."+document.all(i).id).checked=trueOrFalse
			//aaa.checked=true
			}
			
		}
	}

}
//-->
</SCRIPT>

<BODY leftmargin=0 topmargin=0>
<FORM method="post" name="fm_GROUPinfo" id="fm_GROUPinfo" >
<div name="div_type" id="div_type" style='position:absolute;width:100%; height:100%; z-index:1; overflow: auto'>
<table border="1" width="100%" bordercolorlight="#A6A6D6" bordercolordark="#ADDCFA" height="90">
  <tr>
    <td width="100%" height="20" bgcolor="#CCFFCF">一、<img border="0" src="../images/maintenance/method.gif" WIDTH="17" HEIGHT="16">库房 A
    <input type=checkbox  value='ON' onclick="javascript:select_all('A',this.checked)" >全部选中
    </td> 
  </tr> 
  <tr> 
    <td width="100%"> 
      <table border="0" width="100%" background="../images/budget/bg.gif"> 
       <%write_to_table("A")%>
      </table> 
    </td> 
  </tr> 
  <tr> 
    <td width="100%" height="14" bgcolor="#ADDCFA">二、<img border="0" src="../images/maintenance/method.gif" WIDTH="17" HEIGHT="16">管理 B
    <input type=checkbox  value='ON' onclick="javascript:select_all('B',this.checked)">全部选中
    </td> 
   </tr> 
   <tr> 
    <td width="100%" > 
      <table border="0" width="100%" background="../images/budget/bg.gif"> 
       <%write_to_table("B")%>
      </table> 
    </td> 
  </tr> 
  <tr> 
    <td width="100%" height="16" bgcolor="#66CCFF">三、<img border="0" src="../images/maintenance/method.gif" WIDTH="17" HEIGHT="16">网上 C
    <input type=checkbox  value='ON' onclick="javascript:select_all('C',this.checked)" >全部选中
    </td> 
  </tr> 
  <tr> 
    <td width="100%"> 
      <table border="0" width="100%" background="../images/budget/bg.gif"> 
       <%write_to_table("C")%>
      </table> 
    </td> 
  </tr> 
  <tr> 
    <td width="100%" height="16" bgcolor="#CCCCFF">四、<img border="0" src="../images/maintenance/method.gif" WIDTH="17" HEIGHT="16">维护 D
    <input type=checkbox  value='ON' onclick="javascript:select_all('D',this.checked)" >全部选中
    </td> 
  </tr> 
  <tr> 
    <td width="100%"> 
      <table border="0" width="100%" background="../images/budget/bg.gif"> 
       <%write_to_table("D")%>
      </table> 
    </td> 
  </tr> 
</table> 
</div>
</form>
</body> 
 
</html> 
