<!--#include file="../include/ModeRule.asp"-->
<!--#include file="../include/ModeCheckVB.asp"-->
<!--#include file=function/function_pub.asp-->
<!--#include file=function/function_db.asp-->

<style>
TABLE
{
    FONT-SIZE: 12px;
    WIDTH: 100%;
    BORDER-COLLAPSE: collapse
}
</style>
<STYLE>
	select{BORDER:1px solid #3c3;color:white;background-color:#393}
	INPUT {BORDER:1px solid #3c3;color:black;}
</STYLE>
<script language=javascript>
function goback(){
	//window.location.href="UserAdd.asp?userid=<%=userid%>";  
	window.history.go(-1); 
}

function checkValues(){
	ID=document.userAddForm.ID.value;
	NAME=document.userAddForm.NAME.value;
	DEP=document.userAddForm.DEP.value;
	TEL=document.userAddForm.TEL.value;
	GNP=document.userAddForm.GNP.value;
	/*
	IDre=/(?:p|P)\d{6}/g;
	if(!IDre.test(ID)){
		alert("用户帐号填写不正确!")
		document.userAddForm.ID.focus();
		return false;
	}
	*/
	if(ID=="" || ID==null){
		alert("用户帐号填写不正确!")
		document.userAddForm.ID.focus();
		return false;
	}
	if(NAME=="" || NAME==null){
		alert("请填写用户姓名!")
		document.userAddForm.NAME.focus();
		return false;
	}
	if(DEP=="" || DEP==null){
		alert("请填写用户所在部门!")
		document.userAddForm.DEP.focus();
		return false;
	}
	if(TEL=="" || TEL==null){
		alert("请填写联系电话或地址!")
		document.userAddForm.TEL.focus();
		return false;
	}
	if(GNP=="0"){
		alert("请选择用户所在电站!")
		document.userAddForm.GNP.focus();
		return false;
	}
	
	
}

function go(){
	//alert("11")
	var sID=parent.parent.parent.document.all['__USER_ROLE'].value
	//alert(sID)
	form1.innerHTML="<input type=hidden name='userid' value='"+sID+"'>"
	form1.action="userAdd.asp"; 
	form1.submit()
}
</script>
<form name=form1 method=post></form>
<%

tempStr=trim(Request.Form("selectMod"))
adduser=trim(Request.Form("adduser"))
'Response.Write tempStr
if tempStr="DellAll" then
	call DellAll()
elseif tempStr="Dell" then
	call Dell()  
elseif tempStr="Add" then
	call Add() 
elseif tempStr="" and adduser<>"" then
	call Add_user()
end if

sub DellAll()
	userid=Request.Form("userid")
	dellSQL="delete from "&Application("DBOwner")&".Grems_Employee t where t.EP_WORKGROUP is null"
	session("OraAMSCnn").execute(dellSQL)
	Response.Write "<script language=javascript>"
	Response.Write "go()"
	Response.Write "</script>"
end sub

sub Dell()
	userid=Request.Form("userid")
	del_info=trim(Request.Form("del_info"))
	if del_info="" then
		Response.Redirect "userAdd.asp"
	else
		del_info=replace(left(del_info,len(del_info)-1),"check","")
		List=split(del_info,",",-1,1)
		ListNum=ubound(List)
		for i=0 to ListNum
			STRSQL=STRSQL&",'"&List(i)&"'"
		next
		STRSQL=right(STRSQL,len(STRSQL)-1)
		DELLSQL="delete from "&Application("DBOwner")&".Grems_Employee t where t.EP_ID in ("&STRSQL&")"
		'Response.Write DELLSQL
		session("OraAMSCnn").execute(DELLSQL)
		Response.Write "<script language=javascript>"
		Response.Write "go()"
		Response.Write "</script>"
	end if
end sub

sub Add()
	Response.Write "<table border='0' width='100%' ><tr>"
	Response.Write "<form action='user_function.asp' method=post name=userAddForm>"
    Response.Write "<td width='33%' colspan='2'>"
    Response.Write "<fieldset id='fs_sysgroup' name='fs_sysgroup'>"
    Response.Write "<legend><img SRC='../images/collection.gif' WIDTH='16'> 添加用户</legend>"
    Response.Write "<table border='1' width='100%' bgcolor='#339933' bordercolorlight='#444444' bordercolordark='#339933' cellspacing=2 cellpadding=2><tr>"
    Response.Write "<td width='100%'>"
    Response.Write "<table border='1' width='100%' bgcolor='#D8D0C8' bordercolorlight='#ffffff' bordercolordark='#fffff'><tr>"
    Response.Write "<td width='40%'align=right>登录用户帐号&nbsp;</td><td>&nbsp;<input type='text' name='ID' maxlength=7 size=16></td></tr>"
    Response.Write "<tr><td width='40%'align=right>用户姓名&nbsp;</td><td>&nbsp;<input type='text' name='NAME' maxlength=8 size=16></td>"
	Response.Write "<tr><td width='40%'align=right>所在部门&nbsp;</td><td>&nbsp;<input type='text' name='DEP' maxlength=30 size=16></td>"
	Response.Write "<tr><td width='40%'align=right>联系电话/地址&nbsp;</td><td>&nbsp;<input type='text' name='TEL' maxlength=30 size=16></td>"
   	Response.Write "<tr><td width='40%'align=right>所属电站&nbsp;</td><td>&nbsp;<select name='GNP'><option value='0'></option><option value='D'>&nbsp;一核&nbsp;&nbsp;</option><option value='L'>&nbsp;二核&nbsp;&nbsp;</option><option value='A'>&nbsp;一/二核&nbsp;&nbsp;</option></select></td>"
    Response.Write "</td></tr></table>"
    Response.Write "</td><tr><td align=center>"
    Response.Write "<input type=submit name='adduser' value='添加 >>' onclick='return checkValues()' style='CURSOR: hand;border:1px solid white;background-color:#393;color:white;font-size:13px;height:20px;font-weight:bold'>"
    Response.Write "&nbsp;&nbsp;"
    Response.Write "<input type=reset value='取消 >>' style='CURSOR: hand;border:1px solid white;background-color:#393;color:white;font-size:13px;height:20px;font-weight:bold' id=button1 name=button1>"
    Response.Write "&nbsp;&nbsp;"
    Response.Write "<input type=button value='返回 >>' onclick='return goback()' style='CURSOR: hand;border:1px solid white;background-color:#393;color:white;font-size:13px;height:20px;font-weight:bold' id=button1 name=button1>"
    Response.Write "<input type=hidden value="&userid&" name=userid></td></tr>"
    Response.Write "</td></form></tr></table>"
end sub


sub Add_user()
	userid=Request.Form("userid")
	ID=replace(trim(Request.Form("ID")),"'","")
	NAME=replace(trim(Request.Form("NAME")),"'","")
	DEP=replace(trim(Request.Form("DEP")),"'","")
	GNP=replace(trim(Request.Form("GNP")),"'","")
	TEL=replace(trim(Request.Form("TEL")),"'","")
	call checkValues(ID)
	call checkValues(NAME)
	call checkValues(DEP)
	call checkValues(GNP)
	call checkValues(TEL)
	ID=ucase(ID)
	SeSql="select count(EP_ID) from "&Application("DBOwner")&".Grems_Employee where EP_ID='"&ID&"'"
	set SeNum=session("OraAMSCnn").execute(SeSql)
	if cint(SeNum(0))>0 then
		call go_back("此用户已存在!")
	end if
	InSql="insert into "&Application("DBOwner")&".Grems_Employee(EP_ID,EP_NAME,EP_PASSWD,EP_DEPNAME,EP_TEL,EP_STATION) values ('"&ID&"','"&NAME&"','"&ID&"','"&DEP&"','"&TEL&"','"&GNP&"')"
	session("OraAMSCnn").execute(InSql)
	'Response.Redirect "userAdd.asp?userid="&userid&""
	Response.Write "<script language=javascript>"
	Response.Write "go()"
	Response.Write "</script>"
	
end sub


sub checkValues(obj)
	if obj="" or isnull(obj) then
		Response.Write "<script language=javascript>"
		Response.Write "alert('请按要求填写数据');"
		Response.Write "window.history.go(-1);"
		Response.Write "</script>"
		Response.End 
	end if
end sub


sub go_back(str)
		Response.Write "<script language=javascript>"
		Response.Write "alert('"+str+"');"
		Response.Write "window.history.go(-1);"
		Response.Write "</script>"
		Response.End 
end sub
%>