<%
Response.Expires = 0
%>
<style>
TABLE
{
    FONT-SIZE: 12px;
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

select{BORDER:2px solid #3c3;}
input 
{
BORDER:1px solid #3c3;color:black;
}
</style>
<head>
<%session("id")="D03"%>
<!--#include file="check.asp"-->

	<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
	<title>�޸����û�</title>
</head>
<!--#include file=function/function_pub.asp-->
<!--#include file=function/function_db.asp-->
<%

	function CountsSQL(cSQL)
		'ͳ��������
	   set RsCount=server.CreateObject("ADODB.Recordset") 
	   RsCount.Open cSQL,session("OraAMSCnn"),1,1
	   CountsSQL=cint(RsCount.Fields(0))
	   RsCount.Close 
	   set RsCount=nothing
	end function
'---------------------------------------------------
'---------��õ�ǰ����������ƣ��Ա���ٳ���--------
sub get_Group_name(Wg_ID)
	StrSQL="select Wg_name from "&Application("DBOwner")&".Grems_Work_Group where Wg_id='"&Wg_ID&"'"
	returnStr=connect_db(StrSQL)
	
	if cstr(returnStr) <> "0" then 
    	if cstr(returnStr)<>"���ݿ��޼�¼!" then
    	  message "ϵͳ����",cstr(returnStr),0
    	  exit sub
    	 end if
	else
	    Response.Write "��ǰ�������ǣ�"&Session("OraAMSRs").fields("Wg_name")
    	
    end if
end sub

sub insert_option(option_name,cSQL)
			'Response.Write cSQL
			'Response.End 
		
			Session("OraAMSRs").movefirst
			Response.Write "<SCRIPT LANGUAGE=javascript>"
			for i=1 to CountsSQL(cSQL)
				tempStr=trim(Session("OraAMSRs").fields("EP_WorkGroup"))
				if tempStr<>"" then
					tempStr=right(tempStr,len(tempStr)-1)
				end if
				'-------------------��ʽ����-------------------------------
				'-----EP_ID����8λ����ո�Ep_name����9λ����ո�---------
				strTemp=fill_to_string(Session("OraAMSRs").fields("Ep_ID"),8)
				strTemp=strTemp&fill_to_string(Session("OraAMSRs").fields("Ep_Name"),9)
				strTemp=strTemp&fill_to_string(Session("OraAMSRs").fields("Ep_DepName"),9)
				strTemp=strTemp&tempStr
				'-----------------------------------------------------------
				Response.Write "oOption = document.createElement('OPTION')"&";"
				Response.Write "oOption.text="&chr(34)&strTemp&chr(34)&";"
				'oOption.value="5"; 'ȥ��value,������֤��ֵ��������
				Response.Write option_name&".add(oOption)"&";"
				
				                    
				Session("OraAMSRs").movenext
			next
			Response.Write "</SCRIPT>"
end sub

function check_user_ID(user_ID)
	if instr(1,Request.Form("select_users"),user_ID)<>0 then
		check_user_ID="�Ѿ����д��ʺţ�"&user_ID
		exit function
	end if
	check_user_ID="0"
end function

'----------------------------------------------------------
'---------��õ�ǰ����������û���Ϣ��ͨ���б����ʾ-------
sub get_Group_item(Group_ID)
	
	dim returnStr
	if Request.Form.Count<=0 then 

	    'Response.Write CountSQL
		StrSQL="select Ep_ID,Ep_Name,Ep_depName,EP_WorkGroup from "&Application("DBOwner")&".Grems_Employee where EP_WorkGroup like '%"&Ucase(Group_ID)&"%'"
		returnStr=connect_db(StrSQL)
		if cstr(returnStr) <> "0"  then  '�ж��Ƿ�oracle����
			if cstr(returnStr)<>"���ݿ��޼�¼!" then
				message "ϵͳ����",cstr(returnStr),0
				exit sub
			end if
		else
		    CountSQL="select count(Ep_ID) from "&Application("DBOwner")&".Grems_Employee where EP_WorkGroup like '%"&Ucase(Group_ID)&"%'"
		    call insert_option("fm_userinfo.select_users",CountSQL)
		end if
     else 'ȡsubmit��Form�����ݡ�
			for i=1 to Request.Form("select_users").Count 
				Response.Write "<option >"&Request.Form("select_users").Item(i) &"</option>" 'ȥ��value,������֤��ֵ��������
		    next
			
     end if
     StrSQL=""
     CountSQL=""
     Station=trim(Request.Form("EP_STATION"))
     if Station<>"0" then
		LastSQL="and  EP_STATION='"&Station&"'"
     end if
     
     if Request.Form("EP_ID") <> "" then '�ж��Ƿ���������
           
          StrSQL="select Ep_ID,Ep_Name,Ep_depName,EP_WorkGroup,EP_STATION from "&Application("DBOwner")&".Grems_Employee where (EP_WorkGroup not like '%"&Ucase(Group_ID)&"%' or EP_WORKGROUP is null) and EP_ID like '"&trim(Ucase(Request.Form("EP_ID")))&"%'"
		  CountSQL="select count(Ep_ID) from "&Application("DBOwner")&".Grems_Employee where (EP_WorkGroup not like '%"&Ucase(Group_ID)&"%' or EP_WORKGROUP is null) and EP_ID like '"&trim(Ucase(Request.Form("EP_ID")))&"%'"
     else 
	     
			if  Request.Form("EP_name") <> "" then		'ֻ��д������
			   StrSQL="select Ep_ID,Ep_Name,Ep_depName,EP_WorkGroup,EP_STATION from "&Application("DBOwner")&".Grems_Employee where (EP_WorkGroup not like '%"&Ucase(Group_ID)&"%' or EP_WORKGROUP is null)  and Ep_Name like '"&trim(Request.Form("Ep_Name"))&"%'"
			   CountSQL="select count(Ep_ID) from "&Application("DBOwner")&".Grems_Employee where (EP_WorkGroup not like '%"&Ucase(Group_ID)&"%' or EP_WORKGROUP is null)  and Ep_Name like '"&trim(Request.Form("Ep_Name"))&"%'"
  			elseif  Request.Form("EP_DepName") <> "" then 'ֻ��д�˲���
			  if len(Hex(Asc(Request.Form("EP_DepName"))))>2 then  '����
			     StrSQL="select Ep_ID,Ep_Name,Ep_depName,EP_WorkGroup,EP_STATION from "&Application("DBOwner")&".Grems_Employee where (EP_WorkGroup not like '%"&Ucase(Group_ID)&"%' or EP_WORKGROUP is null)  and Ep_depName like '"&trim(Request.Form("Ep_depName"))&"%'"
				 CountSQL="select count(Ep_ID) from "&Application("DBOwner")&".Grems_Employee where (EP_WorkGroup not like '%"&Ucase(Group_ID)&"%' or EP_WORKGROUP is null)  and Ep_depName like '"&trim(Request.Form("Ep_depName"))&"%'"
			  else
			     StrSQL="select Ep_ID,Ep_Name,Ep_depName,EP_WorkGroup,EP_STATION from "&Application("DBOwner")&".Grems_Employee where (EP_WorkGroup not like '%"&Ucase(Group_ID)&"%' or EP_WORKGROUP is null) and  EP_DEPSHORTEN like '"&trim(Ucase(Request.Form("Ep_depName")))&"%'"
				 CountSQL="select count(Ep_ID) from "&Application("DBOwner")&".Grems_Employee where (EP_WorkGroup not like '%"&Ucase(Group_ID)&"%' or EP_WORKGROUP is null) and  EP_DEPSHORTEN like '"&trim(Ucase(Request.Form("Ep_depName")))&"%'"
			  end if
			end if
	end if 
	
	if StrSQL<>"" then 
		StrSQL=StrSQL&LastSQL
		CountSQL=CountSQL&LastSQL
	end if
	'CountSQL=CountSQL&LastSQL
	'Response.Write StrSQL
	'Response.End 
					
	if StrSQL<>"" then  
		returnStr=connect_db(StrSQL)
		if cstr(returnStr) <> "0" then  '�ж��Ƿ�oracle����
					if cstr(returnStr) <>"���ݿ��޼�¼!" then
						message "ϵͳ����",cstr(returnStr),0
					'else
					'	message "ע�⣺","û�鵽����Ҫ����Ϣ����������Ҫ��Ȩ���û��Ѿ��������������",0
					end if
					exit sub
		else
			tt=CountsSQL(CountSQL)
				'if Session("OraAMSRs").RecordCount=0 then 
				if tt=0 then
					message "��ʾ��Ϣ��","û�з���������ѡ�",0
				elseif tt=1 then
			
					returnStr=check_user_ID(Session("OraAMSRs").fields("EP_ID")) '�ж��Ƿ��Ѿ��д�Ա����
					if returnStr="0" then
						strTemp=Session("OraAMSRs").fields("EP_ID")&"  "&Session("OraAMSRs").fields("Ep_Name")&"  "&Session("OraAMSRs").fields("EP_depname")
						Response.Write "<SCRIPT LANGUAGE=javascript>"
						Response.Write "oOption = document.createElement('OPTION')"&";"
						Response.Write "oOption.text="&chr(34)&strTemp&chr(34)&";"
						'oOption.value="5";
						Response.Write "fm_userinfo.select_users.add(oOption)"&";"
						Response.Write "</SCRIPT>"
					else 
						message "���棺",returnStr,0
					end if
				else '�ж��ѡ��
				   'call check_user_ID(user_ID) '�ж��Ƿ��Ѿ��д�Ա����
			'	   			message "���棺",CountSQL,0

				   call show_div(1)
			'	   message "���棺",111,0
				   call insert_option("List_users",CountSQL)
				end if
		end if   
    end if 
	  
end sub

sub show_div(ShowOrHide)
   Response.Write "<SCRIPT ID=clientEventHandlersJS LANGUAGE=javascript>"
   if ShowOrHide=1 then
		Response.Write "Layer_left.style.display='block';"
		Response.Write "Layer_left.style.top=30;"
		Response.Write "Layer_left.style.left=0;"
   else
		Response.Write "Layer_left.style.visibility='hidden';"
   end if
   Response.Write "</SCRIPT>"
end sub 
%>

<script ID="clientEventHandlersJS" LANGUAGE="javascript">

function select_users_ondblclick() {
	var i
	fm_userinfo.select_users.remove(fm_userinfo.select_users.selectedIndex)  
	//for(i=0;i<fm_userinfo.select_users.options.length;i++){
	//alert(fm_userinfo.select_users.options(i).text);
	//}

}
function input_press(sSign){

 if(window.event.keyCode==13){ //����س���
 	Add_item_onclick()
 }
}

function Add_item_onclick() { //ѡ��������ύ
    
    for(i=0;i<fm_userinfo.select_users.options.length;i++){
	     fm_userinfo.select_users.item(i).selected=true
		}
		fm_userinfo.action="GroupUser.asp"
		fm_userinfo.submit() 
}

function List_users_ondblclick() {
     
      //Layer_left.style.visibility='hidden';
      strTemp= List_users.options(List_users.selectedIndex).text;
      totalStr=""
      for(i=0;i<fm_userinfo.select_users.options.length;i++){
	     totalStr=totalStr+fm_userinfo.select_users.item(i).text
		}
		 //���Դ��˺��Ƿ����
      if(totalStr.indexOf(strTemp.substring(0,7))>=0){ 
	     alert("�Ѿ����д��ʺţ�"+strTemp.substring(0,7));
	     }
	   else{
          	
		oOption = document.createElement("OPTION");
		oOption.text=strTemp;
		fm_userinfo.select_users.add(oOption);
	 }
}

function del_item_onclick() {
  if(fm_userinfo.select_users.selectedIndex>=0){
     fm_userinfo.select_users.remove(fm_userinfo.select_users.selectedIndex);
     }
}

function Btn_Moid_onclick() { //�޸�
		for(i=0;i<fm_userinfo.select_users.options.length;i++){
	     fm_userinfo.select_users.item(i).selected=true
		}
		fm_userinfo.action="save_to_group.asp"
		fm_userinfo.submit() 
}

function Btn_Cancel_onclick(tempStr){
  
	location.replace(tempStr)
}
</script>

<body topmargin="0" leftmargin="0" onload="fm_userinfo.EP_ID.focus();return 0;">

<div id="Layer_left" style="position:absolute;display:none;  width:100%; height:116px; z-index:1; left: 0px; top: 0px">
<table border=0 width=100% ><tr><td align=center width=100%>
	<table width=300px bgcolor="#339933" border="2" bordercolorlight="#ffffff" cellspacing="1" bordercolordark="#ffffff">
	<tr><td align="center"><font color="white">�������˫��ѡ���û�</font></td></tr>
	<tr><td>
	<select name="List_users" id="List_users" size="7" multiple LANGUAGE="javascript" ondblclick="return List_users_ondblclick()">
	</select>
	</td></tr>
	<tr><td align="right">
	
	<input type=button value=">> ����" language="javascript" onclick="Layer_left.style.visibility='hidden';" id="button1" name="button1" style="border:2px solid white;background-color:#393;color:white;font-size:13px;height:20px;">
	</td></tr>
	</table>
</td></tr></table>
</div>

<%
if Request.Form.Count <=0 then
	if request("WG_ID")="" then
		Session("Group_ID")="WG001"
	else
		Session("Group_ID")=request("WG_ID")
		
	end if
	
end if
%>
<form method="post" name="fm_userinfo" id="fm_userinfo">
<table border="0" width="100%"  cellspacing="1"   bgcolor=#339933 bordercolorlight="#ffffff" bordercolordark="#ffffff" >
 <tr><td width=100%>
 <table border=1 width=100%><tr><td colspan="3" align="middle" height="20">
 <font style="color:white">
 <%call get_Group_name(Session("Group_ID"))%>
 </font>
 </td></tr></table>
 </td></tr>
 <tr><td>
 <table border=1 bgcolor=#D8D0C8 width=100%>
 <tr>
    <td height="120" valign=top>
        <table border="0" width="100%" cellspacing="0" cellpadding="0" bordercolorlight="#99ccff" bordercolordark="#800000">
        <tr>
         <td colspan="2" align=center height=30 valign=bottom><font color="black">����û�</font></td>
        </tr>
        <tr>
          <td id="setposition" width="100%" align="right" colspan="2">
            <hr width="100%">
          </td>
        </tr>
        <tr>
          <td width="40%" align="right">Ա���ţ�</td>
          <td width="60%"><input name="EP_ID" id="EP_ID" size="16" maxlength="8" tabindex="1" language="javascript" onkeypress="return input_press('ID')" title="������Ա���ţ�����ģ����ѯ"></td>
        </tr>
        <tr>
          <td width="40%" align="right">��&nbsp; ����</td>   
          <td width="60%"><input name="EP_NAME" id="EP_NAME" size="16" maxlength="8" tabindex="2" language="javascript" onkeypress="return input_press('NAME')" title="����������������ģ����ѯ"></td>
        </tr>
        <tr>
          <td width="40%" align="right">��&nbsp; �ţ�</td>   
          <td width="60%"><input name="EP_DEPName" id="EP_DEPname" size="16" maxlength="8" tabindex="3" language="javascript" onkeypress="return input_press('DEP')" title="�����벿�ŵ�һ���ֻ��ŵ���д������ģ����ѯ"></td>
        </tr>
        <tr>
          <td width="40%" align="right">��&nbsp; վ��</td>   
          <td width="60%"><select name="EP_STATION" id="EP_STATION"  language="javascript" title="��ѡ���վ�����в�ѯ"><option  value="0">&nbsp;����&nbsp;</option><option  value="A">&nbsp;һ����&nbsp;</option><option value="D">&nbsp;һ��</option><option value="L">&nbsp;����</option></select></td>
        </tr>
      </table>
     </td></tr>
    <tr>
    <td align="middle" height="40">
        <table border="0" width="100%" cellspacing="0" cellpadding="0" height="40">
          <tr>
            <td width="100%" align="middle" height="37">
            	<input type=button value="���� >>" name="Add_item" id="Add_item" LANGUAGE="javascript" onclick="return Add_item_onclick()" style="border:2px solid #393;background-color:white;color:#393;font-size:13px;height:20px;">
                <input type=button value="<< ɾ��" name="Del_item" id="del_item" LANGUAGE="javascript" onclick="return del_item_onclick()"  style="border:2px solid #393;background-color:white;color:#393;font-size:13px;height:20px;"> 
            </td>
          </tr>
        </table>

    </td></tr>
    <tr>
    <td height="133">
        <table border="0" width="100%" cellspacing="0" cellpadding="0" height="163">
          <tr>
            <td width="100%" align="middle" height="28" valign=bottom><font color="black">��ǰ�������û�</font></td>
          </tr>
          <tr>
            <td width="100%" align="middle" height="135">
               <div id="Layer_right" title="���˫�����Զ�ɾ��"> 
                 <select name="select_users" id="select_users" size="7" multiple LANGUAGE="javascript" ondblclick="return select_users_ondblclick()">
					<%
  					call get_Group_item(Session("Group_ID"))
				%>
               	 </select>
               	   
				</div> 
           </td>
          </tr>
        </table>
    </td>
  </tr></table>
  <table width=100%>
  <tr><td height="25" colspan="3" align="right">
  <input type=button value="�޸� >>" name="Btn_OK" id="Btn_OK" LANGUAGE="javascript" onclick="return Btn_Moid_onclick();"title="�޸Ķ�Ӧ���û������浽���ݿ�" style="border:2px solid white;background-color:#393;color:white;font-size:13px;height:20px;">
  <input type=button value="�ر� >>" name="Btn_Cancel" id="Btn_Cancel" LANGUAGE="javascript" onclick="window.close(); window.opener.location.reload();" title="ȡ����ǰ�޸Ķ��ر�" style="border:2px solid white;background-color:#393;color:white;font-size:13px;height:20px;">
 </td></tr>

</table>
</form>

</body>
  
