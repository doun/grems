<!--#include file="../include/ModeRule.asp"-->
<!--#include file="../include/ModeCheckVB.asp"-->

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
<!--#include file=check.asp-->

	<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
	<link rel="stylesheet" type="text/css" href="../include/ams.css">
	<!--#include file=function/function_pub.asp-->
	<!--#include file=function/function_db.asp-->

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
   //window.location.replace("authGroupmain.asp") 
   	var sID=parent.parent.document.all['__USER_ROLE'].value
	//alert(sID)
	document.form1.innerHTML="<input type=hidden name='userid' value='"+sID+"'>"
	document.form1.action="AuthGroupmain.asp"; 
	document.form1.submit()
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
		
		StrSQL="select WG_ID,WG_NAME,WG_RIGHT,WG_DESC from "&Application("DBOwner")&".Grems_Work_Group  order by wg_id"
		CountSQL="select count(WG_ID) from "&Application("DBOwner")&".Grems_Work_Group"
		returnStr=connect_db(StrSQL)
		if cstr(returnStr) <> "0" then  '�ж��Ƿ�oracle����
			check_valid="ϵͳ����"&cstr(returnStr)
			exit sub
		else
			call insert_option("GROUP_OPTION",CountSQL)
		end if
end sub


function CountsSQL(StrSQL)
		'ͳ��������---------��֪Ϊ��object.RecordCount��ʾΪ-1 
    set RsCount=server.CreateObject("ADODB.Recordset") 
    RsCount.Open StrSQL,session("OraAMSCnn"),1,1
    CountsSQL=cint(RsCount.Fields(0))
    RsCount.Close 
    set RsCount=nothing
end function
	
	
sub insert_option(option_name,CountSQL)
'----------------------------------------------------------
'--���ܣ������ݲ��뵽�б��
'--������option_name:�������ID
'----------------------------------------------------------
	Session("OraAMSRs").movefirst
	WG_right1=Session("OraAMSRs").fields("WG_RIGHT")
				for i=0 to CountsSQL(CountSQL)-1
			
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
<table border="0" width="100%" height="100%" cellspacing="0" cellpadding="1" bordercolorlight="#ffffff" bordercolordark="#339933">
 
  <tr>
    <td width="20%" valign="top" align="middle">
       
       
       <table>
       <tr>
		<td>
		<fieldset id="fs_sysgroup" name="fs_sysgroup">
		<legend><font color="black"><img height="16" src="../images/prop_rw.gif" width="18"> ϵͳ������:</font></legend>  
      <select size="13" border="1" name="GROUP_OPTION" ID="GROUP_OPTION" multiple style="BACKGROUND-COLOR: #339933; BORDER-BOTTOM: thin solid; BORDER-TOP-WIDTH: thin; FONT-SIZE: 10pt; HEIGHT: 279px; LINE-HEIGHT: 100%; LIST-STYLE: none; MARGIN-BOTTOM: 0px; MARGIN-TOP: 0px; TEXT-ALIGN: center; WIDTH: 194px; WORD-SPACING: 0px;color:white" LANGUAGE="javascript" onchange="return GROUP_OPTION_onchange()" title="ѡ��ϵͳ��">
      <%call get_Group() %>
      </select>
       </fieldset> 
       </td>
       </tr>
		<tr>
		<td width="20%" height="11" valign="top" align="middle">
		<input type="button" value="&gt;&gt; �޸�" id="change" language="javascript" name="change" onclick="return Change_OnClick()" src="../images/button/MODI.gif" style="CURSOR: hand;border:2px solid #393;background-color:white;color:#393;font-size:13px;height:20px;font-weight:bold">
		</td> 
		</tr>
		<tr>
		<td width="20%" height="11" valign="top" align="middle">
		<input type="button" value="&gt;&gt; ˢ��" id="close" language="javascript" name="close" onclick="return window.location.reload()" src="../images/button/fresh.gif" style="CURSOR: hand;border:2px solid #393;background-color:white;color:#393;font-size:13px;height:20px;font-weight:bold"> 
		</td> 
		</tr> 
		<tr>
		<td width="20%" height="11" valign="top" align="middle">
		<input type="button" value="&gt;&gt; ����" id="close" language="javascript" name="close" onclick="return close_onclick()" src="../images/button/close.gif" style="CURSOR: hands;border:2px solid #393;background-color:white;color:#393;font-size:13px;height:20px;font-weight:bold"> 
		</td> 
		</tr>
		<tr><td></td></tr> 
      </table>   
     
      
    </td> 
    
    <td width="80%" valign="top" height="100%"> 
        <fieldset id="fs_sysgroup" name="fs_sysgroup">
		<legend><font color="black"><img height="16" src="../images/prop_wo.gif" width="18"> ϵͳ����ģ��:</font></legend>  

		<iframe width="100%" height="370" SCROLLING="no" frameborder="0" name="iFr_right" id="iFr_right" language="javascript" src="AuthGroup_right.asp?Group_Right=<%=WG_right1%>&amp;">
		</iframe> 
		</fieldset>   
    </td>
  </tr>
 
</table>
<form method="post" name="form1" style="display:none">
</form>

<script LANGUAGE="javascript">
<!--
GROUP_OPTION.selectedIndex=0

//-->
</script>

</body>
</html>
