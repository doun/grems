<%@ Language=VBScript %>

<html>
<head>
<%session("id")="D03"%>
<!--#include file=../../login/check_valid.asp-->

	<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
	<link rel="stylesheet" type="text/css" href="../include/ams.css">
	<!--#include file=../function/function_pub.asp-->
	<!--#include file=../function/function_db.asp-->

<script ID="clientEventHandlersJS" LANGUAGE="javascript">

function GROUP_OPTION_onchange() {//�����
	//alert("authgroup_right.asp?Group_Right="+window.GROUP_OPTION.value.substring(5))
	window.iFr_right.document.fm_GROUPinfo.action="authgroup_right.asp?Group_Right="+window.GROUP_OPTION.value.substring(5)
	window.iFr_right.document.fm_GROUPinfo.submit()
}

function Change_OnClick() {//�ύ����
	window.iFr_right.document.fm_GROUPinfo.action="change_group_right.asp?Group_ID="+window.GROUP_OPTION.value.substring(0,5)
	window.iFr_right.document.fm_GROUPinfo.submit()
}
function close_onclick() {
   window.location.replace("authGroupmain.asp") 
}


</script>
<%
dim WG_right1   '���ڱ����һ��ϵͳ���IDֵ
WG_right1=""
sub get_Group()
'----------------------------------------------------------
'--���ܣ���õ�ǰ���й���������Ʋ�ͨ���б����ʾ
'--������         
'----------------------------------------------------------
   	dim returnStr
		
		StrSQL="select WG_ID,WG_NAME,WG_RIGHT,WG_DESC from AMS.Hwork_group order by wg_id"
		returnStr=connect_db(StrSQL)
		if cstr(returnStr) <> "0" then  '�ж��Ƿ�oracle����
			check_valid="ϵͳ����"&cstr(returnStr)
			exit sub
		else
			call insert_option("GROUP_OPTION")
		end if
end sub

sub insert_option(option_name)
'----------------------------------------------------------
'--���ܣ������ݲ��뵽�б��
'--������option_name:�������ID
'----------------------------------------------------------
	Session("OraAMSRs").movefirst
	WG_right1=Session("OraAMSRs").fields("WG_RIGHT")
				for i=0 to Session("OraAMSRs").RecordCount-1
			
				strTemp=fill_to_string(Session("OraAMSRs").fields("WG_ID"),8)'--��ʽ����
				strTemp=strTemp&Session("OraAMSRs").fields("Wg_Name")
				
				'-----------------------���Option����Լ�valueֵ--------------
				Response.Write "<SCRIPT LANGUAGE=javascript>"
				Response.Write "oOption = document.createElement('OPTION')"&";"
				Response.Write "oOption.text="&chr(34)&strTemp&chr(34)&";"
				Response.Write "oOption.value="&chr(34)&Session("OraAMSRs").fields("WG_ID")&Session("OraAMSRs").fields("WG_RIGHT")&chr(34)&";" '�Ա��ж�CHECKBOX
				Response.Write option_name&".add(oOption)"&";"
				Response.Write "</SCRIPT>"
				Session("OraAMSRs").movenext
			next
			
end sub

%>
</head>

<body topmargin="0" leftmargin="0">
    <map name="homepage"><area shape="RECT" coords="670,30,750,65" href="../homepage/index.htm"></map>

<table border="0" width="100%" cellspacing="0" cellpadding="0">
  <tr>
    <td  border="0">
    <IMG border=0 height=70 src="../images/maintenance/right_Model.gif" useMap=#homepage width=778></td>
  </tr>
</table>
<table border="1" width="100%" height="155" cellspacing="0" cellpadding="1" bordercolorlight="#eaeaea" bordercolordark="#99ccff">
 
  <tr>
    <td width="20%" height="146" valign="top" align="middle">
       
       
       <table>
       <tr>
		<td>
		<fieldset id="fs_sysgroup" name="fs_sysgroup">
		<legend><font color="#2233ff"><IMG height=16 src="../images/maintenance/prop_rw.gif" width=18 > ϵͳ������:</font></legend>  
      <select size="13" border=1 name="GROUP_OPTION" ID="GROUP_OPTION" multiple style="BACKGROUND-COLOR: mintcream; BORDER-BOTTOM: thin solid; BORDER-TOP-WIDTH: thin; FONT-SIZE: 11pt; HEIGHT: 279px; LINE-HEIGHT: 100%; LIST-STYLE: none; MARGIN-BOTTOM: 0px; MARGIN-TOP: 0px; TEXT-ALIGN: center; WIDTH: 194px; WORD-SPACING: 0px" LANGUAGE="javascript" onchange="return GROUP_OPTION_onchange()" title="ѡ��ϵͳ��">
      <%call get_Group() %>
      </select>
       </fieldset> 
       </td>
       </tr>
		<tr>
		<td width="20%" height="11" valign="top" align="middle">
		<IMG height=20 id=change language=javascript name=change onclick ="return Change_OnClick()" src="../images/button/MODI.gif"  style="CURSOR: hand" width=77 >
		</td> 
		</tr>
		<tr>
		<td width="20%" height="11" valign="top" align="middle">
		<IMG height=20 id=close language=javascript name=close onclick ="return window.location.reload()" src="../images/button/fresh.gif"  style="CURSOR: hand" width=77 > 
		</td> 
		</tr> 
		<tr>
		<td width="20%" height="11" valign="top" align="middle">
		<IMG height=20 id=close language=javascript name=close onclick ="return close_onclick()" src="../images/button/close.gif"  style="CURSOR: hand" width=77 > 
		</td> 
		</tr> 
      </table>   
     
      
    </td> 
    
    <td width="80%" > 
        <fieldset id="fs_sysgroup" name="fs_sysgroup">
		<legend><font color="#2233ff"><IMG height=16 src="../images/maintenance/prop_wo.gif" width=18> ϵͳ����ģ��:</font></legend>  

		<iframe width="100%" height="365" SCROLLING="no" frameborder="0" name="iFr_right" id="iFr_right" language="javascript" src="AuthGroup_right.asp?Group_Right=<%=WG_right1%>">
		</iframe> 
		</fieldset>   
    </td>
  </tr>
 
</table>

<SCRIPT LANGUAGE=javascript>
<!--
GROUP_OPTION.selectedIndex=0

//-->
</SCRIPT>

</body>
</html>
