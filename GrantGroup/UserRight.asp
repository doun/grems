<title>�û���Ϣ</title>
<%Response.Expires=0%>

<html>
<head>
<%session("id")="D03"%>
<!--#include file=check.asp-->

	<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
	<link rel="stylesheet" type="text/css" href="../include/ams.css">
	<!--#include file=function/function_pub.asp-->
	<!--#include file=function/function_db.asp-->
<title></title>
</head>
<%
EP_WORKGROUP=trim(Request.QueryString("EP_WORKGROUP"))
name=trim(Request.QueryString("name"))
if EP_WORKGROUP<>"" then
	WG=split(EP_WORKGROUP,",",-1,1)
	num=ubound(WG)
else
	Response.Write "<script language=javascript>"
	Response.Write "alert('���û����κ�Ȩ��!');"
	Response.Write "window.close();"
	Response.Write "</script>"
	Response.End 
end if

Group_Right=""
for WG_I=0 to num
	sql="select WG_RIGHT from "&Application("DBOwner")&".grems_work_group where WG_ID='"&WG(WG_I)&"'"
	set RS_WG=session("OraAMSCnn").execute(sql)
	if Group_Right<>"" then
		Group_Right=Group_Right&","
	end if
	Group_Right=Group_Right&RS_WG(0)
	set RS_WG=nothing
next
%>


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
	if cstr(returnStr) <> "0" then		'�ж��Ƿ�oracle����
		message "ϵͳ����",cstr(returnStr),0
		exit sub
	else
			
	'--------------�б���ʾ������ģ��-----------------------
	upModuleID=""	
	up_RightCode=""						'������һ�ε�����
	up_ModuleName=""					'������һ�ε�����
	
	for ii=0 to CountsSQL(contSql)-1 
		if upModuleID<>cstr(Session("OraAMSRs").fields("RC_ModuleID")) then
			if theSame then 
				last="&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp"
			else
				last=""
				
			end if
			theSame=false
			first=true
			
		else							'��ͬ����һ����¼��������һ��
			theSame=true
			
		end if
		
	    if up_ModuleName<>"" then		'��һ���ֿ�
			if theSame then		'����һ����¼һ��,֤������������������ͬ��
			'Response.Write "theSame or last"&theSame&"||"&last
				i=i+1
				if first then			'��������ĸ���
					
					first=false
					tempStr="<TR><td id="&up_RightCode&" width='20%' border=1><label for='"&up_RightCode&"'><input type=checkbox name="&up_RightCode&" ID="&up_RightCode&" value='ON'disabled>"
				else
					if instr(" "&Group_Right,up_RightCode)>0 then
						tempStr="<TR><td id="&up_RightCode&" width='20%' border=1>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp<label for='"&_
								up_RightCode&"'><input type=checkbox name="&up_RightCode&" ID="&up_RightCode&" value='ON'checked>" 
					else
						tempStr="<TR><td id="&up_RightCode&" width='20%' border=1>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp<label for='"&_
								up_RightCode&"'><input type=checkbox name="&up_RightCode&" ID="&up_RightCode&" value='ON'>"
					end if
					
				end if
			else
					
					if instr(" "&Group_Right,up_RightCode)>0 then
						tempStr="<TR><td id="&up_RightCode&" width='20%' border=1>"&last&"<label for='"&_
								up_RightCode&"'><input type=checkbox name="&up_RightCode&" ID="&up_RightCode&" value='ON'checked>"    
					else
						tempStr="<TR><td id="&up_RightCode&" width='20%' border=1>"&last&"<label for='"&_
								up_RightCode&"'><input type=checkbox name="&up_RightCode&" ID="&up_RightCode&" value='ON'>"    
					end if 

			end if
	
			Response.Write tempStr&up_ModuleName&"</label></TD></TR>"
		end if
		up_RightCode=Session("OraAMSRs").fields("RC_RightCode") '������һ�ε�����
		up_ModuleName=Session("OraAMSRs").fields("RC_ModuleName")'������һ�ε�����
		upModuleID=cstr(Session("OraAMSRs").fields("RC_ModuleID"))
		Session("OraAMSRs").MoveNext
		
	next
	'����¼---------------------------------------------
		
			if theSame then 
				last="&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp"
			else
				last=""
				
			end if
			theSame=false
			first=true
			
		
		
			if theSame then		'����һ����¼һ��,֤������������������ͬ��
			'Response.Write "theSame or last"&theSame&"||"&last
				i=i+1
				if first then			'��������ĸ���
					
					first=false
					tempStr="<TR><td id="&up_RightCode&" width='20%' border=1><label for='"&up_RightCode&"'><input type=checkbox name="&up_RightCode&" ID="&up_RightCode&" value='ON'disabled>"
				else
					if instr(" "&Group_Right,up_RightCode)>0 then
						tempStr="<TR><td id="&up_RightCode&" width='20%' border=1>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp<label for='"&_
								up_RightCode&"'><input type=checkbox name="&up_RightCode&" ID="&up_RightCode&" value='ON'checked>" 
					else
						tempStr="<TR><td id="&up_RightCode&" width='20%' border=1>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp<label for='"&_
								up_RightCode&"'><input type=checkbox name="&up_RightCode&" ID="&up_RightCode&" value='ON'>"
					end if
					
				end if
			else
					
					if instr(" "&Group_Right,up_RightCode)>0 then
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
<table border="0" width="100%">
<tr><td align=center><font style="color:black;font-size:10pt"><font color=red><%=name%></font>&nbsp;ϵͳȨ��</td></tr>
</table>
<div name="div_type" id="div_type" style='position:absolute;width:100%; height:100%; z-index:1; overflow: auto'>
<table border="0" width="100%" height="100%"height="90">
  <tr>
    <td width="100%" height="20" bgcolor="#339933"><img border="0" src="../images/method.gif" WIDTH="17" HEIGHT="16">
    <font style="color:white;font-size:10pt">���̹���
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
    <font style="color:white;font-size:10pt">ϵͳά��
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
    <font style="color:white;font-size:10pt">����
    </td> 
  </tr> 
  <tr> 
    <td width="100%" valign=top> 
      <table border="1" width="100%"  bordercolorlight="#339933" bordercolordark="#339933" style="font-size:11pt"> 
       <%write_to_table("C")%>
      </table> 
    </td> 
  </tr> 
 <tr>
    <td width="100%" height="10" bgcolor="#339933"> 
    </td> 
  </tr> 
 <tr><td height="100%" valign=top>
 <table border="1" width="100%"  bordercolorlight="#339933" bordercolordark="#339933" style="font-size:11pt"> 
 <tr><td align=right>
 <input type=button value="�ر� >>" name="Btn_OK" id="Btn_OK" LANGUAGE="javascript" onclick="window.close();"title="�رմ���" style="border:2px solid white;background-color:#393;color:white;font-size:13px;height:20px;">
 </td></tr>
 </table> 
 </td></tr>
</table> 
</div>
</form>
</body> 
 
</html> 
