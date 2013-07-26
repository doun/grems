<%Response.Expires=-1%>
<%
userid=Request.QueryString("userid")
%>
<html>
<head>
<!--#include file=check.asp-->

	<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
	<link rel="stylesheet" type="text/css" href="../include/ams.css">
	<!--#include file=function/function_pub.asp-->
	<!--#include file=function/function_db.asp-->
<title></title>
</head>

<%
function CountsSQL(StrSQL)
    set RsCount=server.CreateObject("ADODB.Recordset") 
    RsCount.Open StrSQL,session("OraAMSCnn"),1,1
    CountsSQL=cint(RsCount.Fields(0))
    RsCount.Close 
    set RsCount=nothing
end function
	
sub Write_to_table(sModel)
	dim upModuleID,theSame,first,last,up_RightCode,up_ModuleName
	theSame=false
	first=true
	last=false
	
	strSQL="select Rc_classID,Rc_className,RC_ModuleID,RC_ModuleID||'.'||RC_ModuleName as RC_ModuleName ,RC_RightCode from "&Application("DBOwner")&".GREMS_RIGHT_CONSTANT where "&Application("DBOwner")&".GREMS_RIGHT_CONSTANT.RC_CLASSID ='"&sModel&"' order by Rc_classID,RC_ModuleID,RC_RightCode"
	contSql="select count(RC_ModuleID) from "&Application("DBOwner")&".GREMS_RIGHT_CONSTANT  where "&Application("DBOwner")&".GREMS_RIGHT_CONSTANT.RC_CLASSID ='"&sModel&"'"

	returnStr=connect_db(StrSQL)
	if cstr(returnStr) <> "0" then		'判断是否oracle出错。
		message "系统错误！",cstr(returnStr),0
		exit sub
	else
			
	'--------------列表显示所有子模块-----------------------
	upModuleID=""	
	up_RightCode=""						'保存上一次的数据
	up_ModuleName=""					'保存上一次的数据
	
	for ii=0 to CountsSQL(contSql)-1 
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
<table border="0" width="100%" height="100%"height="90">
  <tr>
    <td width="100%" height="20" bgcolor="#339933"><img border="0" src="../images/method.gif" WIDTH="17" HEIGHT="16">
    <font style="color:white;font-size:11pt">流程管理
    </td> 
  </tr> 
  <tr> 
    <td width="100%" valign=top> 
      <table border="1" width="100%"  bordercolorlight="#339933" bordercolordark="#339933" style="font-size:11pt"> 
       <%write_to_table("A")%>
      </table> 
    </td> 
  </tr> 
  
  <tr>
    <td width="100%" height="20" bgcolor="#339933"><img border="0" src="../images/method.gif" WIDTH="17" HEIGHT="16">
    <font style="color:white;font-size:11pt">系统维护
    </td> 
  </tr> 
  <tr> 
    <td width="100%" valign=top> 
      <table border="1" width="100%"  bordercolorlight="#339933" bordercolordark="#339933" style="font-size:11pt"> 
       <%write_to_table("B")%>
      </table> 
    </td> 
  </tr> 
  
  <tr>
    <td width="100%" height="20" bgcolor="#339933"><img border="0" src="../images/method.gif" WIDTH="17" HEIGHT="16">
    <font style="color:white;font-size:11pt">其他
    </td> 
  </tr> 
  <tr> 
    <td width="100%" valign=top> 
      <table border="1" width="100%"  bordercolorlight="#339933" bordercolordark="#339933" style="font-size:11pt"> 
       <%write_to_table("C")%>
      </table> 
    </td> 
  </tr> 
</table> 
</div>
<input type=hidden name=userid value=<%=userid%>>
</form>
</body> 
 
</html> 
