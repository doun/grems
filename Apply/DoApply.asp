<!--#include file="../include/pm.asp"-->
<!--#include file="../include/ModeRule.asp"-->
<%
	//检查权限
	setGrant(Request.Form("__USER_ROLE"),getMode())
%>
<html xmlns:v="urn:schemas-microsoft-com:vml"
	  xmlns:o="urn:schemas-microsoft-com:office:office"
	  xmlns:Tools
	  xmlns:FormItem
	  xmlns:OptionTab
>

<link type="text/css" rel="stylesheet" href="..\Library\Default.css">
<link type="text/css" rel="stylesheet" href="../Library/form.css">
<script src="..\Library\default.js"></script>
<script src="..\Library\Shapes.js"></script>
<script language=javascript>
	
	LoadEvent("formatRegion()")
	var _sCurrentTime=new Date().getTime()-eval('<%=new Date().getTime()%>')
</script>
<script language="javascript" src="..\Library/FormInspector.js"></script>
<script language="javascript" src="..\Library\http.js"></script>
<script language="javascript" src="..\Library\date.js"></script>
<script language="javascript" src="..\Library\OptionTab.js"></script>
<script language="javascript" src="..\Library\form.js"></script>
<script>	
	LoadEvent("DoLoad()",600)
	var iGroup		
	var Station,sInputStation=null
	var sSpe='0'
	var sType
	eval("<%=''+Application('PARAM_INFO')%>")
	function DoLoad()
	{
		new WebLoader("wLoader")	
		new FormInputHandler("oForm")
		new OptionTabs("OptionHandler")
		Station=parent.document.all['__USER_STATION'].value
	}
	var formType,resTab
	function LoadFrame(oShape,tab)
	{	
		sInputStation=null			
		sType=formType=oShape.id		
		resTab=tab
		wLoader.push("排放类型",formType)		
		wLoader.load(res,"APP_Form.asp","get")			
	}
	function res(text)
	{								
		var str1=MakeContent(1)+text+button("提交||submitForm()",1)
		resTab.innerHTML=str1
		oForm.InitForm('formposter')
		if(Station=="A")
		{
			var  oTr=formposter.insertRow(0)	
			var oTd=oTr.insertCell()
			var sLabel="<input type=radio style='width:15' "+
				"name=电站 onclick='sInputStation=\"D\";checkStation(this)' id=StationD>"+
				"<label for=StationD>大亚湾核电站</label>"
			oTd.colSpan=2
			oTd.style.textAlign="center"
			oTd.innerHTML=sLabel
			var oTd=oTr.insertCell()
			oTd.style.textAlign="center"
			oTd.colSpan=2
			oTd.innerHTML=sLabel.replace(/D/g,"L").replace("大亚湾","岭澳")
		} else {
			sInputStation=Station
			checkStation(Station)
		}
	}	
	var sSpecialMemo=''
	function bunt(str)
	{
		if(window.confirm(str+"，这是特殊排放，是否继续？"))
		{
			str+="。"
			if(sSpecialMemo=='') sSpecialMemo=str
			else sSpecialMemo+="\n"+str
			return true
		}
		return false
	}
	function checkForm(oFormInst,dom,data)
	{		
		if(sInputStation==null)
		{
			alert1("请选择电站。")
			return false
		}
		if(!checkSpecial(formType)) return false
		wLoader.push("机组",""+iGroup)
		wLoader.push("电站",sInputStation)
		wLoader.push("排放类型",formType)
		wLoader.push("IS_SPECIAL",sSpe)
		wLoader.push("SPECIAL_REASON",sSpecialMemo)	
		return true
	}
	function submitForm()
	{	
		var o=document.all['oMPC']		
		var bReturn=oForm.PostForm(formposter,checkForm,funResult)
		if(bReturn!=false) o.style.display="none"
	}
	function funResult(dom)
	{
		var o=dom.firstChild
		if(o.nodeName!="MESSAGE")
		{			
			document.all['oMPC'].style.display=""
			return
		}		
		TransitionLayer.childNodes[0].style.display=""
		TransitionContent.innerHTML="<br>　　"+o.text
		UnDoneList.location.reload(true)
	}
	function showForm()
	{
		TransitionContent.innerHTML=""
		TransitionLayer.childNodes[0].style.display="none"
		document.all['oMPC'].style.display=""
		OptionHandler.ChangePage(document.all['TER'])
	}
	function LoadList()
	{
		setTimeout(DoLoadList,1000)
	}
	function DoLoadList()
	{		
		setTimeout('UnDoneList.location="../Public/List.asp?s=APP"',1000)
	}
	
<!--#include file="Apply.js"-->	
</script>
<body style="padding:5 10 5 5">	

	<Tools:region title="未完成的申请单列表" style='top:5;right:5;width:100%;height:expression(document.body.offsetHeight-220)' onaction="LoadList()">
	<iframe id="UnDoneList" ></iframe>
	</Tools:region>

	<OptionTab:container ID="oMPC"
		STYLE="position:absolute;color:white;left:3;height:200;bottom:8;width:100%;z-index:2;visibility:hidden" 
		onaction="LoadFrame(this,oRect)"
		EnableShadow='f'
	>
	    <OptionTab:page _ID="TER" TABTEXT="TER排放申请" TABTITLE=""></OptionTab:page>
		<OptionTab:page _ID="SEL" TABTEXT="SEL排放申请" TABTITLE=""></OptionTab:page>
		<OptionTab:page _ID="TEG" TABTEXT="TEG排放申请" TABTITLE=""></OptionTab:page>
		<OptionTab:page _ID="ETY" TABTEXT="ETY排放申请" TABTITLE=""></OptionTab:page>   
		<OptionTab:page _ID="LIQ" TABTEXT="其他液体排放" TABTITLE=""></OptionTab:page>		
		<OptionTab:page _ID="GAS" TABTEXT="其他气体排放" TABTITLE=""></OptionTab:page>   

	</OptionTab:container>	

	<div id="TransitionLayer" style="position:absolute;left:0;width:300;height:130;bottom:50;width:100%;text-align:center">	
		<Tools:region title="申请信息" style='width:300;height:120;display:none'>
		<div style="width:100%;height:100%">
		<table style='height:100%'>
		<tr><td id="TransitionContent" >&nbsp;</td></tr>
		<tr><td style='height:1;text-align:center'>
		<button class='btnSubmit' onclick="this.blur();showForm()">返回</button>
		</td></tr>
		</table>
		</div>
		</Tools:region>	
	</div>	
</body>