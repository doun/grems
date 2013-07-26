<!--#include file="../include/pm.asp"-->
<%
	var sTitle,sList
	sList="authGroupmain.asp";
	sTitle="系统成员维护";
%>
<html xmlns:v="urn:schemas-microsoft-com:vml"
	  xmlns:o="urn:schemas-microsoft-com:office:office"
	  xmlns:Tools
	  xmlns:FormItem
	  xmlns:OptionTab
>

<link type="text/css" rel="stylesheet" href="..\Library\Default.css">
<style>			
 	iframe {position:relative;width:100%;height:100%;border:10px solid #393}    
</style>
<script src="..\Library\default.js"></script>
<script src="..\Library\Shapes.js"></script>
<script language="javascript" src="..\Library\http.js"></script>
<script>
	LoadEvent("DoLoad()")
	function LoadList()
	{
		//UnDoneList.location="<%=sList%>"
	}
	function DoLoad()
	{
		formatRegion()
		new WebLoader("wLoader")
	}
	
//window.name="main"
function windowonload()
{
	var sID=parent.document.all['__USER_ROLE'].value
	//alert(sID)
	document.form1.innerHTML="<input type=hidden name='userid' value='"+sID+"'>"
	document.form1.action="AuthGroupmain.asp"; 
	document.form1.submit()
}
//-->
</script>
<body style="padding:5 10 10 5">	
	<Tools:region title="<%=sTitle%>" style='width:100%;height:expression(document.body.clientHeight-15)' onaction="windowonload()">
	<iframe id="UnDoneList" name="UnDoneList"></iframe>
	</Tools:region>
<form  method=post name=form1 target="UnDoneList" style='display:none'>

</body>