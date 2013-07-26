<!--#include file="../include/pm.asp"-->
<!--#include file="../include/ConstParser.asp"-->
<!--#include file="../include/ModeRule.asp"-->
<%	
	setReferer("Public/showDetail.asp")	
	var sID=""+Request.Form("排放单号")
	var sUID=""+Request.Form("__USER_ROLE")
	var sUserStation=""+Request.Form("__USER_STATION")
	//检查是否有操作本电站的权限
	if(sUserStation!="A"&&sID.substring(0,1)!=sUserStation)
		showErr("对不起，您没有操作另一电站的采样分析排放单的权限")	
	//检查权限
	
	testGrant(sUID)
	var sType=""+Request.Form("排放类型")		
	var cp=new ConstParser()
	var sGroup=cp.getGroup(sType)	
%>
<html xmlns:v="urn:schemas-microsoft-com:vml"
	  xmlns:o="urn:schemas-microsoft-com:office:office"	  	  	  
	  xmlns:Tools
	  xmlns:FormItem
	  xmlns:OptionTab
>
<head>

<link type="text/css" rel="stylesheet" href="../Library/Default.css">
<link type="text/css" rel="stylesheet" href="../Library/form.css">
<script src="../Library/default.js"></script>
<script src="../Library/Shapes.js"></script>
<script language="javascript" src="../Library/FormInspector.js"></script>
<script language="javascript" src="../Library/http.js"></script>
<script language="javascript" src="../Library/date.js"></script>
<script language="javascript" src="../Library/OptionTab.js"></script>
<script language="javascript" src="../Library/form.js"></script>

<script language=javascript>
	var _sCurrentTime=new Date().getTime()-eval('<%=new Date().getTime()%>')
	var sID='<%=sID%>'
	var sType='<%=sType%>'
	var sGroup='<%=sGroup%>'
	var oFun=null,oAdd=null,wLoader=null,sSpecialMemo=''
	var iSpecial=0
	eval("<%=''+Application('PARAM_INFO')%>")
	LoadEvent("DoLoad()")
	
	function DoLoad()
	{
		wLoader=parent.wLoader
		new FormInputHandler("oForm")		
		if(oFun!=null) oFun()
		parent.setForm()
		setTimeout("parent.setForm()",500)
	}
	function reset()
	{
		sSpecialMemo='';iSpecial=0
	}	
	function bunt(str,iFlag)
	{
		var str1=str	
		if(iFlag==null) str1+="，这是特殊排放"
		str1+="，是否继续？"
		if(iFlag==2||window.confirm(str1))
		{
			str+="。"
			if(sSpecialMemo=='') sSpecialMemo=str
			else sSpecialMemo+="\n"+str
			if(iSpecial==0) iSpecial=1
			return true
		}
		return false
	}
	function checkForm(oFormInst,dom,data)
	{
		wLoader.push("排放单号",sID)
		wLoader.push("排放类型",sType)
		wLoader.push("状态",parent.parent.sCurrentStatus)		
		if(oAdd!=null&&!oAdd(oFormInst,dom,data)) return false
		wLoader.push("IS_SPECIAL",iSpecial)
		wLoader.push("SPECIAL_REASON",sSpecialMemo)
		return true
	}
	function funResult(dom)
	{
		top.opener.UnDoneList.location.reload(true)
		parent.location.reload(true)
	}	
	function sh(iHeight) {}	
	function setTitle(str)
	{
		tdTitle.innerHTML=str
	}
	document.write("<body>"+MakeContent())
</script>