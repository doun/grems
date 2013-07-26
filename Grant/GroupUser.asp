<%
Response.Expires = 0
%>
<head>
<%session("id")="D03"%>
<!--#include file=../../login/check_valid.asp-->

	<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
	<link rel="stylesheet" type="text/css" href="../include/ams.css">
</head>
<!--#include file=../function/function_pub.asp-->
<!--#include file=../function/function_db.asp-->
<%

'---------------------------------------------------
'---------获得当前工作组的名称，以便减少出错--------
sub get_Group_name(Wg_ID)
	StrSQL="select Wg_name from ams.Hwork_group where Wg_id='"&Wg_ID&"'"
	returnStr=connect_db(StrSQL)
	
	if cstr(returnStr) <> "0" then 
    	if cstr(returnStr)<>"数据库无记录!" then
    	  message "系统错误！",cstr(returnStr),0
    	  exit sub
    	 end if
	else
	    Response.Write "当前工作组是："&Session("OraAMSRs").fields("Wg_name")
    	
    end if
end sub

sub insert_option(option_name)
			Session("OraAMSRs").movefirst
			Response.Write "<SCRIPT LANGUAGE=javascript>"
			for i=1 to Session("OraAMSRs").RecordCount
				'-------------------格式调整-------------------------------
				'-----EP_ID不满8位补充空格，Ep_name不满9位补充空格---------
				strTemp=fill_to_string(Session("OraAMSRs").fields("Ep_ID"),8)
				strTemp=strTemp&fill_to_string(Session("OraAMSRs").fields("Ep_Name"),9)
				strTemp=strTemp&Session("OraAMSRs").fields("Ep_DepName")
				'-----------------------------------------------------------
				Response.Write "oOption = document.createElement('OPTION')"&";"
				Response.Write "oOption.text="&chr(34)&strTemp&chr(34)&";"
				'oOption.value="5"; '去掉value,这样保证其值等于内容
				Response.Write option_name&".add(oOption)"&";"
				
				                    
				Session("OraAMSRs").movenext
			next
			Response.Write "</SCRIPT>"
end sub

function check_user_ID(user_ID)
	if instr(1,Request.Form("select_users"),user_ID)<>0 then
		check_user_ID="已经含有此帐号："&user_ID
		exit function
	end if
	check_user_ID="0"
end function

'----------------------------------------------------------
'---------获得当前工作组里的用户信息并通过列表框显示-------
sub get_Group_item(Group_ID)
	dim returnStr
	if Request.Form.Count<=0 then 
	    'Response.Write Group_ID
		StrSQL="select Ep_ID,Ep_Name,Ep_depName from ams.HEmployee where EP_WorkGroup='"&Ucase(Group_ID)&"'"
		'message "aa",StrSQL,0
		returnStr=connect_db(StrSQL)
		if cstr(returnStr) <> "0"  then  '判断是否oracle出错。
			if cstr(returnStr)<>"数据库无记录!" then
				message "系统错误！",cstr(returnStr),0
				exit sub
			end if
		else
		    call insert_option("fm_userinfo.select_users")
		end if
     else '取submit后Form的数据。
			
			for i=1 to Request.Form("select_users").Count 
				Response.Write "<option >"&Request.Form("select_users").Item(i) &"</option>" '去掉value,这样保证其值等于内容
		    next
			
     end if
     StrSQL=""
     if Request.Form("EP_ID") <> "" then '判断是否增加数据
           
          StrSQL="select Ep_ID,Ep_Name,Ep_depName from ams.HEmployee where ep_WorkGroup is null and EP_ID like '"&trim(Ucase(Request.Form("EP_ID")))&"%'"
     else 
	     
			if  Request.Form("EP_name") <> "" then		'只填写了姓名
			   StrSQL="select Ep_ID,Ep_Name,Ep_depName from ams.HEmployee where ep_WorkGroup is null  and Ep_Name like '"&trim(Request.Form("Ep_Name"))&"%'"
  
  			elseif  Request.Form("EP_DepName") <> "" then '只填写了部门
			  if len(Hex(Asc(Request.Form("EP_DepName"))))>2 then  '汉字
			     StrSQL="select Ep_ID,Ep_Name,Ep_depName from ams.HEmployee where ep_WorkGroup is null  and Ep_depName like '"&trim(Request.Form("Ep_depName"))&"%'"
			  else
			     StrSQL="select Ep_ID,Ep_Name,Ep_depName from ams.HEmployee where ep_WorkGroup is null and  EP_DEPSHORTEN like '"&trim(Ucase(Request.Form("Ep_depName")))&"%'"
			  end if
			end if
	end if 
	if StrSQL<>"" then  
		'message "提示信息：",StrSQL,0
		returnStr=connect_db(StrSQL)
		if cstr(returnStr) <> "0" then  '判断是否oracle出错。
					if cstr(returnStr) <>"数据库无记录!" then
						message "系统错误：",cstr(returnStr),0
					else
						message "注意：","没查到您需要的信息，或者你需要授权的用户已经存在其它的组里！",0
					end if
					exit sub
		else
				
				if Session("OraAMSRs").RecordCount=0 then 
					message "提示信息：","没有符合条件的选项！",0
				elseif Session("OraAMSRs").RecordCount=1 then
					returnStr=check_user_ID(Session("OraAMSRs").fields("EP_ID")) '判断是否已经有此员工号
					if returnStr="0" then
						strTemp=Session("OraAMSRs").fields("EP_ID")&"  "&Session("OraAMSRs").fields("Ep_Name")&"  "&Session("OraAMSRs").fields("EP_depname")
						Response.Write "<SCRIPT LANGUAGE=javascript>"
						Response.Write "oOption = document.createElement('OPTION')"&";"
						Response.Write "oOption.text="&chr(34)&strTemp&chr(34)&";"
						'oOption.value="5";
						Response.Write "fm_userinfo.select_users.add(oOption)"&";"
						Response.Write "</SCRIPT>"
					else 
						message "警告：",returnStr,0
					end if
				else '有多个选项
				   'call check_user_ID(user_ID) '判断是否已经有此员工号
				   call show_div(1)
				   call insert_option("List_users")
				end if
		end if   
    end if 
	  
end sub

sub show_div(ShowOrHide)
   Response.Write "<SCRIPT ID=clientEventHandlersJS LANGUAGE=javascript>"
   if ShowOrHide=1 then
		Response.Write "Layer_left.style.visibility='visible';"
		Response.Write "Layer_left.style.top=30;"
		Response.Write "Layer_left.style.left=50;"
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

 if(window.event.keyCode==13){ //处理回车！
 	Add_item_onclick()
 }
}

function Add_item_onclick() { //选中所有项并提交
    
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
		 //测试此账号是否存在
      if(totalStr.indexOf(strTemp.substring(0,7))>=0){ 
	     alert("已经含有此帐号："+strTemp.substring(0,7));
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

function Btn_Moid_onclick() { //修改
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
<div id="Layer_left" style="position:absolute;visibility:hidden;  width:200px; height:116px; z-index:1; left: 0px; top: 0px">
	<table bgcolor="#D8D0C8" border="2" bordercolorlight="#99ccff" cellspacing="1" bordercolordark="#800000">
	<tr><td align="center"><font color="blue">请鼠标左健双击选择用户</font></td></tr>
	<tr><td>
	<select name="List_users" id="List_users" size="7" multiple LANGUAGE="javascript" ondblclick="return List_users_ondblclick()">
	</select>
	</td></tr>
	<tr><td align="right">
	
	<img SRC="../images/button/ok.gif" language="javascript" onclick="Layer_left.style.visibility='hidden';" id="button1" name="button1" WIDTH="77" HEIGHT="20">
	</td></tr>
	</table>
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
<table border="2" width="100%" bordercolorlight="#99ccff" cellspacing="1" bordercolordark="#800000" height="213">
 <tr><td colspan="3" align="middle" height="16"><%call get_Group_name(Session("Group_ID"))%></td></tr>
 <tr>
    <td width="39%" height="133">
        <table border="0" width="100%" cellspacing="0" cellpadding="0" bordercolorlight="#99ccff" bordercolordark="#800000">
        <tr>
          <td width="50%" align="middle"><img SRC="../images/maintenance/user.gif" WIDTH="64" HEIGHT="64">
          </td>
          <td width="50%"><font color="#800080">添加用户</font></td>
        </tr>
        <tr>
          <td id="setposition" width="100%" align="right" colspan="2">
            <hr width="80%">
          </td>
        </tr>
        <tr>
          <td width="50%" align="right">员工号：</td>
          <td width="50%"><input name="EP_ID" id="EP_ID" size="16" maxlength="8" tabindex="1" language="javascript" onkeypress="return input_press('ID')" title="请输入员工号，进行模糊查询"></td>
        </tr>
        <tr>
          <td width="50%" align="right">姓&nbsp; 名：</td>   
          <td width="50%"><input name="EP_NAME" id="EP_NAME" size="16" maxlength="8" tabindex="2" language="javascript" onkeypress="return input_press('NAME')" title="请输入姓名，进行模糊查询"></td>
        </tr>
        <tr>
          <td width="50%" align="right">部&nbsp; 门：</td>   
          <td width="50%"><input name="EP_DEPName" id="EP_DEPname" size="16" maxlength="8" tabindex="3" language="javascript" onkeypress="return input_press('DEP')" title="请输入部门的一部分或部门的缩写，进行模糊查询"></td>
        </tr>
      </table>
     
    </td>
    <td width="27%" align="middle" height="133">
        <table border="0" width="100%" cellspacing="0" cellpadding="0" height="75">
          <tr>
            <td width="100%" align="middle" height="37">
            	<img SRC="../images/button/add_to.gif" name="Add_item" id="Add_item" LANGUAGE="javascript" onclick="return Add_item_onclick()" WIDTH="76" HEIGHT="20">
            </td>
          </tr>
          <tr>
            <td width="100%" align="middle" height="38">
            <img SRC="../images/button/del_to.gif" name="Del_item" id="del_item" LANGUAGE="javascript" onclick="return del_item_onclick()" WIDTH="76" HEIGHT="20"> 
            </td>
          </tr>
        </table>

    </td>
    <td width="34%" height="133">
        <table border="0" width="100%" cellspacing="0" cellpadding="0" height="163">
          <tr>
            <td width="100%" align="middle" height="28"><font color="#800080">当前组所含用户</font></td>
          </tr>
          <tr>
            <td width="100%" align="middle" height="135">
               <div id="Layer_right" title="鼠标双击将自动删除"> 
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
  </tr>
  <tr><td height="25" colspan="3" align="right">
  <img SRC="../images/button/MODI.gif" name="Btn_OK" id="Btn_OK" LANGUAGE="javascript" onclick="return Btn_Moid_onclick();" WIDTH="77" HEIGHT="20" title="修改对应项用户，保存到数据库">
  <img SRC="../images/button/close.gif" name="Btn_Cancel" id="Btn_Cancel" LANGUAGE="javascript" onclick="window.close(); window.opener.location.reload();" WIDTH="77" HEIGHT="20" title="取消当前修改而关闭">
 </td></tr>

</table>
</form>

</body>
