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
		UnDoneList.location="../Public/List.asp?s=SAM"
	}
	function DoLoad()
	{
		formatRegion()
		new WebLoader("wLoader")
	}
</script>
<body style="padding:5 10 10 5">	
	<Tools:region title="等待取样的申请单" style='width:100%;height:expression(document.body.clientHeight-15)' onaction="LoadList()">
	<iframe id="UnDoneList"></iframe>
	</Tools:region>

</body>