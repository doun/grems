<%Response.Expires=0 %>
<html>
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
<head>
<%session("id")="D03"%>
<!--#include file=check.asp-->

	<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
	<!--#include file=function/function_pub.asp-->
	<!--#include file=function/function_db.asp-->

	
<title>�޸�ϵͳ��</title>
<%
sub Update_group_to_db()
	if  Request.Form.Count>0 then '���ύ����
		StrSQL="update "&Application("DBOwner")&".Grems_Work_Group set WG_NAME='"&Request.Form("Group_Name")&"',WG_Desc='"&Request.Form ("Group_Detal")&"' where WG_ID='"&Request("WG_ID")&"'"
		returnStr=connect_db(StrSQL)
		if cstr(returnStr) <> "0" and returnStr<>"���ݿ��޼�¼!" then  '�ж��Ƿ�oracle����
			message "ϵͳ����",cstr(returnStr),0
			exit sub
		else
		    message "��ϲ��","�û����޸ĳɹ���",0
		    Response.Write "<SCRIPT LANGUAGE=javascript>"
	        Response.Write "Btm_cancel_onclick()"
			Response.Write "</SCRIPT>"
			runatclient("window.opener.window.location.replace('AuthGroupTop.asp') ")

		end if
	end if 
end sub

Function get_group_items(item)
		StrSQL="select WG_ID,WG_NAME,WG_DESC,WG_RIGHT from "&Application("DBOwner")&".Grems_Work_Group where WG_ID='"&Request("WG_ID")&"'"
		returnStr=connect_db(StrSQL)
		if cstr(returnStr) <> "0" then  '�ж��Ƿ�oracle����
			message "ϵͳ����",cstr(returnStr),0
			exit Function
		else
			if (Session("OraAMSRs").BOF and Session("OraAMSRs").EOF) then
			get_group_items=""
			else
			get_group_items=session("OraAmsRs").fields(item)
			end if
		   
		end if
end Function
%>

<script ID="clientEventHandlersJS" LANGUAGE="javascript">

function fm_update_group_Validator(theForm)
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

function Btn_modi_onclick(WG_ID) {
if(fm_update_group_Validator(fm_update_group)){
  fm_update_group.action="Modi_Group.asp?WG_ID="+WG_ID
  fm_update_group.submit()
 }
}


</script>
</head>
<body topmargin="0" leftmargin="0" bgcolor=#339933>

<form id="fm_update_group" method="post" target="modi_Group" name="fm_update_group">
    <div align="center">
      <center>
	 <fieldset id="fs_sysgroup" name="fs_sysgroup">
	<legend><font style='font-size:12px;color:white'><img SRC="../images/method.gif" WIDTH="18" HEIGHT="16"> �޸�ϵͳ�飺</font></legend>

<table border="0" width="400" cellspacing="2" cellpadding="2" height="180">
     <tr><td>
     <table border=1 bordercolorlight="#ffffff" bordercolordark="#ffffff" bgcolor="#D8D0C8"> 	   <tr>
	    <td align="right" width="102">ϵͳ��ID�ţ�</td>
	    <td width="290"><%=Request("WG_ID")%></td>
	  </tr>
	  <tr>
	    <td  align="right" width="102">ϵͳ�����ƣ�</td>
	    <td  width="290">
           <input name="Group_Name" size="54" value="<%=get_group_items("WG_NAME")%>" maxlength="20" style="width: 285; height: 22"></td>
	  </tr>
	  <tr>
	    <td align="right" width="102">ϵͳ��˵����</td>
	    <td  width="290"><textarea name="Group_Detal" rows="5" cols="38"><%=get_group_items("WG_DESC")%></textarea></td>
	  </tr>
	  <tr>
	    <td align="right" width="102">��</td>
	    <td width="290">
	    <input type=button value=">> �޸�" name="Btn_modi" id="Btn_modi" LANGUAGE="javascript" onclick="return Btn_modi_onclick('<%=request("WG_ID")%>')" style="border:2px solid #393;background-color:white;color:#393;font-size:13px;height:20px;">
	    <input type=button value=">> ȡ��" name="Btm_cancel" id="Btm_cancel" LANGUAGE="javascript" onclick="return Btm_cancel_onclick()"style="border:2px solid #393;background-color:white;color:#393;font-size:13px;height:20px;">
	    </td>
	  </tr>
	</table>
	<br>
	</td>
	  </tr>
	</table>
      </center>
    </div>
	</form>
	<script LANGUAGE="javascript">
	<!--
	window.name="modi_Group"
	//-->
	</script>
	<%Update_group_to_db%>
</body>
</html>
