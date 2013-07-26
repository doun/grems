<!--#include file="../include/pm.asp"-->
<script>
	//checkDroit("M01","11","<%=Application("Work_Group")%>","<%=Application("Work_Group")%>")
</script>
<%
	var sContent=""+Request.QueryString("content")
	var sTitle,sList
	switch(sContent)
	{
		case "YEAR":sTitle="年度统计总表";sList="StatisticList.asp";break
		case "TER":sTitle="TER全年统计总表";sList="StatisticTER.asp";break
		case "SEL":sTitle="SEL全年统计总表";sList="StatisticSEL.asp";break
		case "ETY":sTitle="ETY全年统计总表";sList="StatisticETY.asp";break
		case "TEG":sTitle="TEG全年统计总表";sList="StatisticTEG.asp";break
		case "MONTH":sTitle="月度统计";sList="StatisticMonth.asp";break
		case "SEARCH":sTitle="任务查询";sList="StatisticSearch.asp";break
	}
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
		var sID=parent.parent.document.all['__USER_ROLE'].value
		//alert(sID)
		form1.innerHTML="<input type=hidden name='userid' value='"+sID+"'>"
		form1.target="UnDoneList" 
		form1.action='<%=sList%>'; 
		form1.submit()
	}
	
	function DoLoad()
	{
		formatRegion()
		new WebLoader("wLoader")
	}


//-->
</SCRIPT>
</script>
<body style="padding:5 10 10 5">	
	<Tools:region title="<%=sTitle%>" style='width:100%;height:expression(document.body.clientHeight-15)' onaction="LoadList()">
	<iframe id="UnDoneList" name="UnDoneList"></iframe>
	</Tools:region>
<form action="" method=post name=form1  style='display:none'>
</form>
</body>
