<!--#include file="../include/pm.asp"-->
<!--#include file="../include/ModeRule.asp"-->
<%	
	var selRow=""+Request.Form("selectedRow")
	var selID=selRow
	var sID=""+Request.Form("__USER_ID")
	var sGroup=""+Request.Form("__USER_ROLE")
	var oM=new ModeRuleObject()	
	var SvVars=Request.ServerVariables
	var sLocation=("http://" + SvVars("SERVER_NAME") + SvVars("SCRIPT_NAME")).toLowerCase().split("public")[0]
	sLocation+="print/"
%>

<html xmlns:v="urn:schemas-microsoft-com:vml"
	  xmlns:o="urn:schemas-microsoft-com:office:office"
	  xmlns:Tools
	  xmlns:FormItem
	  xmlns:OptionTab
>
<HEAD>
<TITLE>单号：<%=selID%></TITLE>
<link type="text/css" rel="stylesheet" href="..\Library\Default.css">
<style>			
 	iframe {position:relative;width:100%;height:100%}    
 	body {background-color:green} 	
 	button {background-color:#393;color:white;font-size:9pt;border:1px solid white;vertical-align:middle}
</style>
<script language="javascript" src="..\Library\default.js"></script>
<script language="javascript" src="..\Library\http.js"></script>
<script language="javascript">
	LoadEvent("DoLoad()")	
	window.resizeTo(screen.width-100,screen.availHeight-100)
	window.moveTo(50,50)
	window.focus()
	var xForm
	var sCurrentStatus,sStation
	var sCurrentUser=null
	function DoLoad()
	{
		try { new WebLoader("wLoader")		
		xForm=wLoader.correctPage(2)
		} catch(exp) {window.close()}
		sStation=xForm.__USER_STATION.value
		document.all['frmMsgDetail'].src="ShowDetail.asp?id=<%=selID%>"
		window.setInterval("if(window.opener==null) window.close()",500)
	}
	function DoModify(mode,type)
	{
		
	}
	function setStatus(url,o)
	{
		if(o!=null&&!window.confirm("您将执行的是“"+o.innerText+"”操作，要继续么？")) return false
		wLoader.push('排放单号',frmMsgDetail.排放单号.innerText.Trim())
		wLoader.push('排放类型',frmMsgDetail.排放类型.innerText.Trim())
		wLoader.push('状态',sCurrentStatus)
		wLoader.load(getResult,url)
	}
	function getResult(o)
	{
		tblOtherButton.outerHTML="<table style='width:1;height:1;' id=tblOtherButton><tr></tr></table>"
		window.opener.UnDoneList.location.reload(true)
		if(o.firstChild.nodeName=="MESSAGE") {		
			frmMsgDetail.location.reload(true)
		}	
	}
	function createButton(sName,sFun,sFlag)
	{
		var o=sFlag==null?tblButton:tblOtherButton		
		var oCell=o.rows[0].insertCell(0)
		oCell.innerHTML="<nobr><button value='"+sName+"' style='border:0;background:url(../images/button.gif) no-repeat;width:100;height:22'"+
			"onclick='this.blur();"+sFun+"' "+
			">"+sName+"</button></nobr>"
	}
	function openWin(url)
	{		
		clearButtons()
		var sText=event.srcElement.value
		sCurrentUser=wLoader.getText("//__USER_ID")
		frmMsgDetail.openWin(url,sText)
	}
	function collateUser(sName)
	{		
		return frmMsgDetail.document.all["EXECUTER_"+sName].innerHTML==wLoader.getText("//__USER_ID")
	}
	function clearButtons()
	{
		tblOtherButton.outerHTML="<table style='width:1;height:1;' id=tblOtherButton><tr></tr></table>"
		tblButton.outerHTML="<table style='width:1;height:1' id=tblButton><tr></tr></table>"
	}
	function Print(prompt, frame) 
	{
		frame.DoPrint()
	}
	
	function setButtons(s,s1)
	{
		//alert(s)
		clearButtons()
		sCurrentStatus=s
		var sUrl=window.opener.location.href
		createButton('打印','Print(false,frmMsgDetail)',0)
		createButton('关闭','window.close()',0)	
		if(sStation!="A"&&s1!=sStation) return
		if(s=="END"&&sCurrentUser!=null) {
			Print(false,frmMsgDetail)
			return
		}
		<%if(checkGrant(sGroup,oM.Rules.apply._default)) {%>
		
		switch(s)
		{							
			case "APP":				
				//if(collateUser('APP')) {
					createButton('修改申请','openWin("../Apply/ModifyApply.asp")')	
					createButton('取消申请','setStatus("../Apply/CancleApply.asp",this)')
				//}	
				break						
			case "AQT":
				//alert(wLoader.getText("//__USER_ID"))
				if(collateUser('APP')) {
					createButton('修改申请','openWin("../Apply/ModifyApply.asp")')	
					createButton('取消申请','setStatus("../Apply/CancleApply.asp",this)')
				}	
				break	
		}<%}if(checkGrant(sGroup,oM.Rules.sample._default)) {%>
		switch(s)
		{		
			case "APP":
				createButton('正在取样','setStatus("../Sample/StartSample.asp",this)')
				createButton('退回给申请人','openWin("../Sample/UnTreadApplyMain.asp")')
				break			
			case "SMP":
				if(collateUser("SAM")) {
					createButton('取消取样','setStatus("../Sample/StartSample.asp?ActionFlag=true",this)')					
				}	
				createButton('完成取样','openWin("../Sample/PostSample.asp")')
				break
			case "ALS":
				if(collateUser("SAM")) {
					createButton('修改取样单','openWin("../Sample/PostSample.asp")')
					createButton('退回给申请人','openWin("../Sample/UnTreadApplyMain.asp")')				
				}			
				break
			case "SQT":
				if(collateUser("SAM")) {
					createButton('修改取样单','openWin("../Sample/PostSample.asp")')
					createButton('退回给申请人','openWin("../Sample/UnTreadApplyMain.asp")')
				}	
				break
			case "CTA":
				createButton('提交TER申请单','openWin("../Apply/PostTER.asp")')
				break	
		}<%} if(checkGrant(sGroup,oM.Rules.analyze._default)) {%>		
		switch(s)
		{	
			case "ALS":							
				createButton('填写分析单','openWin("../Analyze/PostAnalyzeMain.asp")')
				createButton('退回给取样人','openWin("../Analyze/CancelAnalyzeMain.asp")')				
				break
			case "CQT":
				if(collateUser("SAL")) {
					createButton('退回给取样人','openWin("../Analyze/CancelAnalyzeMain.asp")')
					createButton('修改分析单','openWin("../Analyze/PostAnalyzeMain.asp")')
				}					
				break						
			case "ISA":		
				if(collateUser("SAL")) createButton('修改分析单','openWin("../Analyze/PostAnalyzeMain.asp")')
				createButton('退回给取样人','openWin("../Analyze/CancelAnalyzeMain.asp")')
				break
		}<%} if(checkGrant(sGroup,oM.Rules.check._default)) {%>			
		switch(s)
		{	
			case "ISA":		
				if(!collateUser("SAL")) createButton('提交检查单','openWin("../check/chekMain.asp")')
				break
			case "MQT":						
			case "CHK":		
				if(collateUser("CHK")) createButton('修改检查单','openWin("../check/chekMain.asp")')
				break	
		}<%} if(checkGrant(sGroup,oM.Rules.confirm._default)) {%>
			if(s=="CHK") createButton('审批','openWin("../confirm/confirmMain.asp","doConfirm(formInput)")')
				createButton('取消审批','openWin("../confirm/confirmMain.asp","doConfirm(formInput)")')		
			<%} if(checkGrant(sGroup,oM.Rules.confirm.confirmmain2)) {%>	
			if(s=="CFM") createButton('特殊排放审批','openWin("../confirm/confirmMain2.asp")')
		<%} if(checkGrant(sGroup,oM.Rules.release._default)) {%>
		switch(s)
		{								
			case "RLS":			
				createButton('开始排放','openWin("../release/releaseMain.asp")')
				break		
			case "RLG":
				createButton('完成本次排放','openWin("../release/EndReleaseMain.asp")')
				break	
			case "HLT":
				createButton('继续排放','openWin("../release/releaseMain.asp")')
				break	
			case "PUS":
				createButton('恢复排放','openWin("../release/releaseMain.asp")')
				break
			case "CTA":		
		}
		<%}%>	
	}	
</script>
</HEAD>
<body style="margin:0">	
	<!--打印控件-->
	
	<table style='width:100%;height:100%' cellspacing=0>
	<tr><Td colspan=2 style='padding:10'><iframe id='frmMsgDetail'></iframe></td></tr>
	<tr><Td style="height:1;padding:0 0 0 10">
	<table style='width:1;height:1;' id=tblButton><tr>	</tr></table></td>
	<td style='height:1;width:1;padding:0 10 0 0'>
		<table style='width:1;height:1;' id=tblOtherButton><tr> </tr></table>
	</td>
	</tr></table>
    <optiontab:p>
        </optiontab:p>
</body>