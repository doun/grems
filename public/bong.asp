<%Response.Expires=-1%>
<html xmlns:v="urn:schemas-microsoft-com:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:Tools>
<style>
BODY
{
    BORDER-RIGHT: 0px;
    BORDER-TOP: 0px;
    OVERFLOW: hidden;
    BORDER-LEFT: 0px;
    BORDER-BOTTOM: 0px;   
    border:3px ridge yellow
}
v\:*
{
    BEHAVIOR: url(#default#VML)
}
o\:*
{
    BEHAVIOR: url(#default#VML)
}
v\:oval
{
	z-index:1;position:absolute;top:1100;width:280;height:420;
	
}
v\:textpath
{
	font-family:Arial;font-size:12px
}
.sp
{
	width:550;height:300;top:1550;
}
v\:textbox
{
	font-size:12px;font-weight:bold;color:green;font-family:Arial
}
v\:group {
	width:300;height:150
}
#c1,#c2,#c3,#c4 {width:420;height:630}
</style>
<script>

//var ary=[a1,a2,a3,a4,b1,b2,b3,b4]
function setBeng(o)
{
	if(o.eb!='t') {o.eb='t';o.fillcolor="#9acd32"}
	else {o.eb=null;o.fillcolor="white"}
	iA=0;iB=0
	var ary=[a1,a2,a3,a4,b1,b2,b3,b4]	
	for(var i=0;i<ary.length;i+=2)
	{
		var x1=(ary[i].eb=='t')?true:false
		var x2=(ary[i+1].eb=='t')?true:false
		if(x1&&x2) iB+=1
		else if(x1||x2) iA+=1
	}	
	ary=[c1,c2,c3,c4]
	var iC=0
	for(var i=0;i<ary.length;i++) {if(ary[i].eb=='t') ++iC}	
	SEC1.innerText=iA
	SEC2.innerText=iB
	CRF.innerText=iC	
	parent.setCounter(iA,iB,iC)
}
</script>
<body>
<v:shapetype coordsize="4000,3000" id="shape1" strokecolor="green">
<v:path v="m0,0 l 1600,0 1600,2500 t -800,0 l 800,0 t -800,3000 l 0 2500,4000,2500,4000,3000 t -1600,-500 l 2400,0 4000,0 t -800,0 l 3200,2500 e"
	fillOK='f' textboxrect="50,50,750,350"
/>
</v:shapetype>

<v:shapetype coordsize="1000,1000" id="shape2" >
<v:path v="m 0,0 l 1000,0,1000,1000,0,1000 xe" fillOK='f' strokeok='f' textboxrect='0,0,1000,1000' />

</v:shapetype>


<v:group id="group1" coordsize="4000,3000">
<v:shape style='z-index:0;width:4000;height:3000;left:0;top:0' coordsize='4000,3000' type="#shape1" >
<v:textbox inset='0 0 0 0' style='font-family:黑体;color:red'>一号机</v:textbox>
</v:shape>
<v:oval id='a1' onclick='setBeng(this)' style='left:660' strokecolor="green" />
<v:oval id='a2' onclick='setBeng(this)' style='left:1460' strokecolor="green" />
<v:oval id='a3' onclick='setBeng(this)' style='left:2260' strokecolor="green" />
<v:oval id='a4' onclick='setBeng(this)' style='left:3060' strokecolor="green" />
<v:shape class='sp' coordsize="1000,1000" type="#shape2" style="left:300" >
<v:textbox inset='0 0 0 0'>001PO</v:textbox>
</v:shape>
<v:shape class='sp' coordsize="1000,1000" type="#shape2" style="left:1100" >
<v:textbox inset='0 0 0 0'>003PO</v:textbox>
</v:shape>
<v:shape class='sp' coordsize="1000,1000" type="#shape2" style="left:1900" >
<v:textbox inset='0 0 0 0'>002PO</v:textbox>
</v:shape>
<v:shape class='sp' coordsize="1000,1000" type="#shape2" style="left:2700" >
<v:textbox inset='0 0 0 0'>004PO</v:textbox>
</v:shape>
</v:group>
<br><br>
<v:group id="group2" coordsize="4000,3000">
<v:shape style='z-index:0;width:4000;height:3000;left:0;top:0' coordsize='4000,3000' type="#shape1" >
<v:textbox inset='0 0 0 0' style='font-family:黑体;color:red'>二号机</v:textbox>
</v:shape>
<v:oval id='b1' onclick='setBeng(this)' style='left:660' strokecolor="green" />
<v:oval id='b2' onclick='setBeng(this)' style='left:1460' strokecolor="green" />
<v:oval id='b3' onclick='setBeng(this)' style='left:2260' strokecolor="green" />
<v:oval id='b4' onclick='setBeng(this)' style='left:3060' strokecolor="green" />
<v:shape class='sp' coordsize="1000,1000" type="#shape2" style="left:300" >
<v:textbox inset='0 0 0 0'>001PO</v:textbox>
</v:shape>
<v:shape class='sp' coordsize="1000,1000" type="#shape2" style="left:1100" >
<v:textbox inset='0 0 0 0'>003PO</v:textbox>
</v:shape>
<v:shape class='sp' coordsize="1000,1000" type="#shape2" style="left:1900" >
<v:textbox inset='0 0 0 0'>002PO</v:textbox>
</v:shape>
<v:shape class='sp' coordsize="1000,1000" type="#shape2" style="left:2700" >
<v:textbox inset='0 0 0 0'>004PO</v:textbox>
</v:shape>
</v:group>

<v:rect style='position:absolute;left:270;top:20;height:20;width:150' >
<v:path strokeok='f' />
<v:textbox inset='0 0 0 0' style='color:darkorange'>SEC单台投运数：<SPAN ID='SEC1'>0</SPAN>台</v:textbox>
</v:rect>
<v:rect style='position:absolute;left:270;top:50;height:20;width:150' >
<v:path strokeok='f' />
<v:textbox inset='0 0 0 0' style='color:darkorange'>SEC整列投运数：<SPAN ID='SEC2'>0</SPAN>列</v:textbox>
</v:rect>

<v:group style='position:absolute;left:270;top:80;height:50;width:135' coordsize="4000,2000">
<v:rect style='width:100%;height:100%' strokecolor='green'>
<v:textbox inset='0 0 0 0' style='color:darkorange'>
CRF泵投运台数：<SPAN ID='CRF'>0</SPAN>台
</v:textbox>
</v:rect>
<v:oval id='c1' onclick='setBeng(this)' style='left:660' strokecolor="green" />
<v:oval id='c2' onclick='setBeng(this)' style='left:1460' strokecolor="green" />
<v:oval id='c3' onclick='setBeng(this)' style='left:2260' strokecolor="green" />
<v:oval id='c4' onclick='setBeng(this)' style='left:3060' strokecolor="green" />
</v:group>

<v:rect style='position:absolute;left:350;top:300;height:18;width:60' >
<v:path strokeok='f' />
<v:textbox inset='0 0 0 0' onmousedown='parent.oPopB.hide()' style='background-color:#4a4;text-align:center;color:white;cursor:hand;font:14px 楷体_GB2312'>关闭</v:textbox>
</v:rect>


</body>