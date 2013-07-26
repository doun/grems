<html xmlns:OptionTab 
 xmlns:v="urn:schemas-microsoft-com:vml"
 xmlns:o="urn:schemas-microsoft-com:office:office"
>
<!--Last Modified At 03/05/14。我在IE6下搞的，IE5效果怎么样，我就不知道了-->
<style>
body {border:0;margin:0;overflow:hidden;background-color:green}
v\:* {behavior:url(#default#VML);}
o\:* {behavior:url(#default#VML);}
Tools\:* {visibility:hidden} 
table {width:100%;height:100%;border-collapse:collapse;font-size:12px;color:white}
iframe {width:100%;height:100%;position:relative;border:0}
button {border:1px solid white;background-color:green;color:white}
</style>
<script language=javascript src="tab1.js"></script>
<script>
var mpc
function window.onload()
{
	mpc=document.getElementsByTagName("container")	
	new OptionTabs("OptionHandler")
}
function show(x,y)
{
	alert("这是"+x.TABTEXT)
}
</script>
<body>

	<OptionTab:container id="oMPC"
	STYLE="color:white;position:absolute;top:10;left:30;height:200;width:350;visibility:hidden" 
	EnableShadow='f'
	>
	  <OptionTab:page _ID="TER" TABTEXT="第一项" TABTITLE="">
	  <input type=radio checked name=a>男<input name=a type=radio>女<br>
	  <input id=text1 name=text1><br><input id=text2 name=text2><br>
	  <input type=submit style="background-color:green:color:white;border:1px solid white" id=submit1 name=submit1>
	  </OptionTab:page>
		<OptionTab:page _ID="SEL" TABTEXT="第二项" TABTITLE="" onaction="oRect.innerHTML='<iframe src=http://www.google.com></iframe>'">
		<iframe></iframe>
		</OptionTab:page>
		<OptionTab:page _ID="TEG" TABTEXT="第三项" TABTITLE="" >没有内容</OptionTab:page>
		<OptionTab:page _ID="ETY" TABTEXT="第四项" TABTITLE="" onaction="show(this,oRect)"></OptionTab:page>  
	</OptionTab:container> 
	
	<OptionTab:container id="oMPC"
	STYLE="color:white;position:absolute;top:10;right:30;height:200;width:350;visibility:hidden" 
	Rotation=90
	>
	  <OptionTab:page _ID="TER" TABTEXT="第一项" TABTITLE="">
		<button onclick="OptionHandler.set(mpc[1],'rotation',270)" name="v">左</button>&nbsp;
		<button onclick="OptionHandler.set(mpc[1],'rotation',90)" name="v1">右</button>&nbsp;
		<button onclick="OptionHandler.set(mpc[1],'rotation',0)" name="v1">上</button>&nbsp;
		<button onclick="OptionHandler.set(mpc[1],'rotation',180)" name="v1">下</button>&nbsp;
		<button onclick="OptionHandler.addTab(mpc[1])" name="v1">加</button>&nbsp;
		<button onclick="OptionHandler.removeTab(mpc[1],mpc[1].children[0].children.length-1)" name="v1">减</button><br><br>
		<button onclick="OptionHandler.set(mpc[1],'shadowon',true)" name="v1">添加阴影</button>&nbsp;
		<button onclick="OptionHandler.set(mpc[1],'shadowon',false)" name="v1">去除阴影</button>
	  </OptionTab:page>		
	</OptionTab:container> 

	