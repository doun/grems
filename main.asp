<!--#include file="include/pm.asp"-->
<!--#include file="include/ApplicationAdd.asp"-->
<%	
	var oDate=new Date()
	var sDate=(oDate.getMonth()+1)+"月"+(oDate.getDate())+"日"
	delete oDate

%>
<html xmlns:v="urn:schemas-microsoft-com:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:Tools>
<head>
<title>核电站放射性液态气态流出物排放管理系统</title>
<link type="text/css" rel="stylesheet" href="Library\Default.css">
<link type="text/css" rel="stylesheet" href="Library\xtree.css">
<script src="Library\default.js"></script>
<script src="Library\SizeFormater.js"></script>
<script src="Library\Shapes.js"></script>
<script src="Library\http.js"></script>
<script src="Library\xtree.js"></script>
<style>
table {width:100%;height:100%;border-collapse:collapse;font-size:12px;color:white}
</style>
<script language="javascript">
	//new Image('images/file.png')
	LoadEvent("DoLoad()")		
	function DoLoad()
	{
		new WebLoader("wLoader",true)
		wLoader.push('CURRENT_USER','<%=Request.Form("UserID")%>')
		wLoader.load(setUserInfo,"include/user_info.asp")
	}	
	new SizeAranger("Sizer")	
	LoadEvent("InitShape()",500)		
	function setUserInfo(oDoc)
	{				
		window.globalUserInfo=oDoc.selectSingleNode("//__USER_INFO")		
		var oTr=infoArea		
		oTr.cells(1).innerHTML=oDoc.selectSingleNode("//__USER_NAME").text
		oTr.cells(3).innerHTML=oDoc.selectSingleNode("//__USER_DEPT").text
		var sStation		
		switch(oDoc.selectSingleNode("//__USER_STATION").text)
		{
			case "A":sStation="一/二核";break
			case "D":sStation="一核";break
			case "L":sStation="二核";break
			default:window.location.href="Public/message.asp?s=在您的信息中，无法查知您所属的电站";return
		}
		oTr.cells(5).innerHTML=sStation
		oTr.style.visibility="visible"
		oTr=null
		PostRight.innerHTML=""
		var oNodes=oDoc.selectNodes("//__USER_INFO/*")
		for(var i=0;i<oNodes.length;i++)
		{
			var sName=oNodes[i].nodeName
			var o=document.createElement("<INPUT type=hidden id='"+sName+"' name='"+sName+"' value='"+oNodes[i].text+"' />")
			PostRight.appendChild(o)
		}		
		BuildTree(oDoc.selectSingleNode("//TREE"))
		try {
			txtBoxTreeInfo.all.tags("A")[1].focus()
			txtBoxTreeInfo.all.tags("A")[1].click()
		} catch(exp) {}	
	}
	function getNode(oNode)
	{
		var o=new WebFXTreeItem(
			oNode.getAttribute("name"),
			oNode.getAttribute("action"),
			null,null,null,
			oNode.getAttribute("close")
		)
		var iLength=oNode.childNodes.length
		for(var i=0;i<iLength;i++) o.add(getNode(oNode.childNodes[i]))
		return o
	}
	function BuildTree(oRoot)
	{		
		var tree = new WebFXTree(oRoot.getAttribute("name"));
		var oNodes=oRoot.childNodes
		for(var i=0;i<oNodes.length;i++) tree.add(getNode(oNodes[i]))		
		txtBoxTreeInfo.innerHTML=tree.toString()		
	}
	function LoadPage(src)
	{
		if(src=="Public/right.asp") document.all['frmRight'].src=src
		else {		
			if(window.globalUserInfo==null)
			{
				alert("请您先登陆！")
				return
			}
			PostRight.action=src
			PostRight.submit()
		}
	}
	function openWin(sUrl)
	{
		var sHeight=window.screen.availHeight-100
		var sWidth=window.screen.availWidth-100
		window.open(sUrl,"chaowei","height="+sHeight+",width="+sWidth+",left=50,top=50,location=0,scrollbars=1")
	}
	function ExitLogon()
	{
		document.clear()
		window.location.href="default.asp"
	}
	

	
</script>
</head>
<body>
<table cellpadding="0" cellspacing="0">
<tr><td style="height:72">
<img src="images/title.gif" style="height:100%;width:100%" / WIDTH="800" HEIGHT="72">
</td></tr>
<tr><td>
<table>
	<tr><td style="WIDTH: 150px">	&nbsp;
	</td>
	<td id="tdfrmRight">
	<iframe id="frmRight" src="Public/right.asp" name="RIGHTFRAME"></iframe>
	</td>
	</tr>
</table>
</tr></table>
<v:roundrect style="RIGHT:10px; WIDTH: 190px; POSITION: absolute; 
	TOP: 10px; HEIGHT: 40px" strokecolor="green" arcsize="0.2" path=" m0,0 qx2000,2000,4000,4000,20000,4000,20000,0 x e">
	<v:fill type="gradient" color="#add600" color2="#b1fe02" />
	<v:textbox>
		<table cellpadding="0" style="visibility:hidden;color:darkgreen" id="infoArea">
		<tr><td>用户:</td><td >&nbsp;</td><td>部门:</td><td>&nbsp;</td></tr>
		<tr><td>电站:</td><td>&nbsp;</td><td>日期:</td><td><%=sDate%></td></tr>
		</table>
	</v:textbox>
</v:roundrect>
<v:roundrect id="Tree" style="LEFT: 5px;WIDTH: 145px;BOTTOM: 9px" strokecolor="#ffd700" fillcolor="#4a4" arcsize="3000f" sizeformat="height:100%-87;">
   <v:textbox style="COLOR: white" inset="0 0 0 0" id=txtBoxTreeInfo></v:textbox>
</v:roundrect>
<form id="PostRight" method="POST" style="display:none" target="RIGHTFRAME"></form>
</body>
</html>
