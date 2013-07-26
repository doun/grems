<!--#include file="../include/pm.asp"-->
<%
	var sTitle,sList
	sList="userAdd.asp";
	sTitle="ÓÃ»§Î¬»¤";
%>
<html xmlns:v="urn:schemas-microsoft-com:vml"
	  xmlns:o="urn:schemas-microsoft-com:office:office"
	  xmlns:Tools
	  xmlns:FormItem
	  xmlns:OptionTab
>
<SCRIPT LANGUAGE=javascript>
<!--
function LoadList()
{
	var sID=parent.parent.document.all['__USER_ROLE'].value;
	//alert(sID)
	form1.innerHTML="<input type=hidden name='userid' value='"+sID+"'>";
	form1.target="UnDoneList1"; 
	form1.action="userAdd.asp"; 
	form1.submit()
}
//-->
</SCRIPT>
<link type="text/css" rel="stylesheet" href="..\Library\Default.css">
<style>			
 	iframe {position:relative;width:100%;height:100%;border:10px solid #393}    
</style>
<script src="..\Library\default.js"></script>
<script src="..\Library\Shapes.js"></script>
<script language="javascript" src="..\Library\http.js"></script>
<script>
	LoadEvent("DoLoad()")
	
	function DoLoad()
	{
		formatRegion()
		new WebLoader("wLoader")
	}
</script>
<body style="padding:5 10 10 5">	

	<Tools:region title="<%=sTitle%>" style='width:100%;height:expression(document.body.clientHeight-15)' onaction="LoadList()">
	<iframe id="UnDoneList1" name="UnDoneList1"></iframe>
	</Tools:region>
<form method=post name=form1  style='display:none'>
</form>
</body>
