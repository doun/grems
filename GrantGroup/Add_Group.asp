<html>
<head>
<style>
TABLE
{
    FONT-SIZE: 12px;
    WIDTH: 100%;
    BORDER-COLLAPSE: collapse
}
TEXTAREA {		
		scrollbar-face-color:#393;
		scrollbar-arrow-color:white;
		scrollbar-highlight-color:white;
		scrollbar-3dlight-color:green;
		scrollbar-shadow-color:white;
		scrollbar-darkshadow-color:greenf;
		scrollbar-track-color:#eef;
		BORDER:1px solid #3c3;color:black;
	}
input 
{
BORDER:1px solid #3c3;color:black;
}
</style>
</style>
<%session("id")="D03"%>
<!--#include file=check.asp-->


	<!--#include file=function/function_pub.asp-->
	<!--#include file=function/function_db.asp-->
	
	
<title>����ϵͳ��</title>
<%
sub add_group_to_db()
	if  Request.Form.Count>0 then '���ύ����
	    '-----------�Զ�����û�����------------------------
	    StrSQL="select max(WG_ID) from "&Application("DBOwner")&".Grems_Work_Group"
		returnStr=connect_db(StrSQL)
		if cstr(returnStr) <> "0"   then  '�ж��Ƿ�oracle����
			if cstr(returnStr)= "���ݿ��޼�¼!" then
				tempStr="GP001"
			else
				call message("ϵͳ����",cstr(returnStr),0)
				exit sub
			end if
			
		else
			tempStr=session("OraAmsRs").fields(0)
			tempStr1=mid(tempStr,1,2)
			tempStr2=cstr(cint(mid(tempStr,3))+1)  '��ǰ���ֵ��һ
			if tempStr2>"99" then 
			    message "���棺","̫����û��飬��ɾ�������û��飡",0
			    exit sub
			end if
			if len(tempStr2)=1 then
			     tempStr2="00"&tempStr2
			 elseif len(tempStr2)=2 then
				tempStr2="0"&tempStr2
			end if
			tempStr=tempStr1&(tempStr2)
		end if
		
		
		StrSQL="insert into "&Application("DBOwner")&".Grems_Work_Group(WG_ID,WG_NAME,WG_DESC) values('"&tempStr&"','"&Request.Form("Group_Name")&"','"&Request.Form ("Group_Detal")&"')"
		
		returnStr=connect_db(StrSQL)
		if cstr(returnStr) <> "0" and cstr(returnStr)<> "���ݿ��޼�¼!" then  '�ж��Ƿ�oracle����
			call message("ϵͳ����",cstr(returnStr),0)
			exit sub
		else
		    message "��ϲ��","�û������ӳɹ���",0
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
    alert("ϵͳ�����Ʋ���Ϊ�գ�");
    theForm.Group_Name.focus();
    return (false);
  }
  if (theForm.Group_Name.value.length > 20)
  {
    alert("ϵͳ�����Ʋ��ܳ���20���ַ���");
    theForm.Group_Name.focus();
    return (false);
  }
  if (theForm.Group_Detal.value.length > 50)
  {
    alert("ϵͳ���������ܳ���50���ַ���");
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
<body topmargin="0" leftmargin="0" bgcolor=#339933>

<form id="fm_add_group" method="post" target="Add_Group" name="fm_add_group">
    <div align="center">
      <center>
	<fieldset id="fs_sysgroup" name="fs_sysgroup">
	<legend><img SRC="../images/method.gif" WIDTH="16"><font style='font-size:12px;color:white'> ����ϵͳ�飺</font></legend>
	<table border="0" width="400" cellspacing="2" cellpadding="2" height="180">
     <tr><td>
     <table border=1 bordercolorlight="#ffffff" bordercolordark="#ffffff" bgcolor="#D8D0C8"> 
      <tr>
	    <td align="right" width="102">ϵͳ��ID�ţ�</td>
	    <td  width="290">��</td>
	  </tr>
	  <tr>
	    <td  align="right" width="102">ϵͳ�����ƣ�</td>
	    <td  width="290">
        
	    <input name="Group_Name" size="54" maxlength="20" style="width: 285; height: 22"></td>
	  </tr>
	  <tr>
	    <td align="right" width="102">ϵͳ��˵����</td>
	    <td  width="290"><textarea name="Group_Detal" rows="5" cols="38"></textarea></td>
	  </tr>
	  <tr>
	    <td  align="right" width="102">��</td>
	    <td  width="290">
	    <input type=button value=">> ����" name="Btn_ADD" id="Btn_ADD" LANGUAGE="javascript" onclick="return Btn_ADD_onclick()" style="border:2px solid #393;background-color:white;color:#393;font-size:13px;height:20px;">
	    <input type=button value=">> ȡ��" name="Btm_cancel" id="Btm_cancel" LANGUAGE="javascript" onclick="return Btm_cancel_onclick()" style="border:2px solid #393;background-color:white;color:#393;font-size:13px;height:20px;">
	    </td>
	  </tr>
	</table>
	<br>
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
