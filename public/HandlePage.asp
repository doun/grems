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
<TITLE>���ţ�<%=selID%></TITLE>
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
		if(o!=null&&!window.confirm("����ִ�е��ǡ�"+o.innerText+"��������Ҫ����ô��")) return false
		wLoader.push('�ŷŵ���',frmMsgDetail.�ŷŵ���.innerText.Trim())
		wLoader.push('�ŷ�����',frmMsgDetail.�ŷ�����.innerText.Trim())
		wLoader.push('״̬',sCurrentStatus)
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
		createButton('��ӡ','Print(false,frmMsgDetail)',0)
		createButton('�ر�','window.close()',0)	
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
					createButton('�޸�����','openWin("../Apply/ModifyApply.asp")')	
					createButton('ȡ������','setStatus("../Apply/CancleApply.asp",this)')
				//}	
				break						
			case "AQT":
				//alert(wLoader.getText("//__USER_ID"))
				if(collateUser('APP')) {
					createButton('�޸�����','openWin("../Apply/ModifyApply.asp")')	
					createButton('ȡ������','setStatus("../Apply/CancleApply.asp",this)')
				}	
				break	
		}<%}if(checkGrant(sGroup,oM.Rules.sample._default)) {%>
		switch(s)
		{		
			case "APP":
				createButton('����ȡ��','setStatus("../Sample/StartSample.asp",this)')
				createButton('�˻ظ�������','openWin("../Sample/UnTreadApplyMain.asp")')
				break			
			case "SMP":
				if(collateUser("SAM")) {
					createButton('ȡ��ȡ��','setStatus("../Sample/StartSample.asp?ActionFlag=true",this)')					
				}	
				createButton('���ȡ��','openWin("../Sample/PostSample.asp")')
				break
			case "ALS":
				if(collateUser("SAM")) {
					createButton('�޸�ȡ����','openWin("../Sample/PostSample.asp")')
					createButton('�˻ظ�������','openWin("../Sample/UnTreadApplyMain.asp")')				
				}			
				break
			case "SQT":
				if(collateUser("SAM")) {
					createButton('�޸�ȡ����','openWin("../Sample/PostSample.asp")')
					createButton('�˻ظ�������','openWin("../Sample/UnTreadApplyMain.asp")')
				}	
				break
			case "CTA":
				createButton('�ύTER���뵥','openWin("../Apply/PostTER.asp")')
				break	
		}<%} if(checkGrant(sGroup,oM.Rules.analyze._default)) {%>		
		switch(s)
		{	
			case "ALS":							
				createButton('��д������','openWin("../Analyze/PostAnalyzeMain.asp")')
				createButton('�˻ظ�ȡ����','openWin("../Analyze/CancelAnalyzeMain.asp")')				
				break
			case "CQT":
				if(collateUser("SAL")) {
					createButton('�˻ظ�ȡ����','openWin("../Analyze/CancelAnalyzeMain.asp")')
					createButton('�޸ķ�����','openWin("../Analyze/PostAnalyzeMain.asp")')
				}					
				break						
			case "ISA":		
				if(collateUser("SAL")) createButton('�޸ķ�����','openWin("../Analyze/PostAnalyzeMain.asp")')
				createButton('�˻ظ�ȡ����','openWin("../Analyze/CancelAnalyzeMain.asp")')
				break
		}<%} if(checkGrant(sGroup,oM.Rules.check._default)) {%>			
		switch(s)
		{	
			case "ISA":		
				if(!collateUser("SAL")) createButton('�ύ��鵥','openWin("../check/chekMain.asp")')
				break
			case "MQT":						
			case "CHK":		
				if(collateUser("CHK")) createButton('�޸ļ�鵥','openWin("../check/chekMain.asp")')
				break	
		}<%} if(checkGrant(sGroup,oM.Rules.confirm._default)) {%>
			if(s=="CHK") createButton('����','openWin("../confirm/confirmMain.asp","doConfirm(formInput)")')
				createButton('ȡ������','openWin("../confirm/confirmMain.asp","doConfirm(formInput)")')		
			<%} if(checkGrant(sGroup,oM.Rules.confirm.confirmmain2)) {%>	
			if(s=="CFM") createButton('�����ŷ�����','openWin("../confirm/confirmMain2.asp")')
		<%} if(checkGrant(sGroup,oM.Rules.release._default)) {%>
		switch(s)
		{								
			case "RLS":			
				createButton('��ʼ�ŷ�','openWin("../release/releaseMain.asp")')
				break		
			case "RLG":
				createButton('��ɱ����ŷ�','openWin("../release/EndReleaseMain.asp")')
				break	
			case "HLT":
				createButton('�����ŷ�','openWin("../release/releaseMain.asp")')
				break	
			case "PUS":
				createButton('�ָ��ŷ�','openWin("../release/releaseMain.asp")')
				break
			case "CTA":		
		}
		<%}%>	
	}	
</script>
</HEAD>
<body style="margin:0">	
	<!--��ӡ�ؼ�-->
	
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