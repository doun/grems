<!--#include file="../include/pm.asp"-->
<!--#include file="../include/ModeRule.asp"-->
<%
	var sAction=""+Request.QueryString("Action")
	var sTitle,sList
	switch(sAction)
	{
		case "APP":
		case "DEFAULT":
			sTitle="δ��ɵ����뵥";
			sList="List.asp?s="+sAction;
			break
		case "SAMPLE":sTitle="����";sList="List.asp?s=SAM";break
		case "ANALYZE":sTitle="����";sList="List.asp?s=ANA";break
		case "CHECK":sTitle="���";sList="List.asp?s=CHK";break
		case "CONFIRM":sTitle="����";sList="List.asp?s=COM";break
		case "SPCONFIRM":sTitle="��������";sList="List.asp?s=CM2";break
		case "RELEASE":sTitle="�ŷ�";sList="List.asp?s=RLS";break
	}
	//���Ȩ��
	if(sAction!="DEFAULT")
	{
		sAction=(sAction=="SPCONFIRM")?"confirm._confirmmain2":sAction.toLowerCase()+"._default"
		setGrant(Request.Form("__USER_ROLE"),getMode(sAction))
	}	
	sTitle=sTitle+"�б�"
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
		setTimeout('UnDoneList.location="<%=sList%>"',500)
	}
	function DoLoad()
	{
		formatRegion()
		new WebLoader("wLoader")
	}
</script>
<body style="padding:5 10 10 5">	
	<Tools:region title="<%=sTitle%>" style='width:100%;height:expression(document.body.clientHeight-15)' onaction="LoadList()">
	<iframe id="UnDoneList"></iframe>
	</Tools:region>

</body>