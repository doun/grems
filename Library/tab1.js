
String.prototype.Trim=function()
{
	return this.replace(/(^\s|\s$)*/g,"")
}
String.prototype.convert=function(bFlag)
{
	var re,j
	if(bFlag==true) {re=/[^\x00-\xff]/g;j=-1}
	else {re=/[\x00-\xff]/g;j=1}
	var t=this.toString()
	var x=t.match(re)	
	if(x!=null) {
		for(var i=0;i<x.length;i++)
			t=t.replace(x[i],String.fromCharCode(x[i].charCodeAt(0)+j*0xfee0))		
	}
	return t
}
//adj参数说明：0：标签离左边的距离，1：标签的宽度
var sOptionTabPath= 'm0,@10qy@11,@5,'+
	'		@7,@5,'+
	'		@7,@22qy@14,@21,'+
	'		@16,@21qx@15,@22,'+
	'		@15,@5,'+
	'		@18,@5qx@17,@10,'+
	'		@17,@20qy@18,@19, @4,@19qx0,@20xe'
var sOptionTabRect="@7,@13,@15,@24"
sOptionTabPath1=sOptionTabPath
	.replace(/(@?\d+),(@?\d+)/g,"$2,$1")
	.replace(/qy/g,"qv")
	.replace(/qx/g,"qy")
	.replace(/qv/g,"qx")
sOptionTabRect1=sOptionTabRect.replace(/(@?\d+),(@?\d+)/g,"$2,$1")
	
var sModel='<v:shapetype id="hOptionTabModal" bIsOptionTabShape="t" \n' +
	'	coordsize="21600,21600"\n'+
	'	adj="8000,4000,0"\n'+	
	'>\n'+
	'<v:shadow on="t" offset="1pt,1pt" type="emboss" />\n'+
	'<v:path v="'+sOptionTabPath+'"'+
	'		textboxrect="'+sOptionTabRect+'"\n'+
	'	/>\n'+
	'	<v:formulas>\n'+
/*00*/	'		<v:f eqn="val pixelwidth"/>\n'+			
/*01*/	'		<v:f eqn="val pixelheight"/>\n'+			
/*02*/	'		<v:f eqn="prod 21600 1 @0"/>\n'+			
/*03*/	'		<v:f eqn="prod 21600 1 @1"/>\n'+				
/*04*/	'		<v:f eqn="prod @2 7 1"/>\n'+			
/*05*/	'		<v:f eqn="prod @3 19 1"/>\n'+
/*06*/	'		<v:f eqn="sum @5 @4 0"/>\n'+
/*07*/	'		<v:f eqn="val #0"/>\n'+	
/*08*/	'		<v:f eqn="prod @1 100 @0" />\n'+
/*09*/	'		<v:f eqn="prod @4 100 @8" />\n'+
/*10*/	'		<v:f eqn="sum @5 @9 0"/>\n'+
/*11*/	'		<v:f eqn="if @7 @4 0"/>\n'+
/*12*/	'		<v:f eqn="prod @4 1 3"/>\n'+
/*13*/	'		<v:f eqn="prod @12 100 @8"/>\n'+
/*14*/	'		<v:f eqn="sum @7 @12 0"/>\n'+
/*15*/	'		<v:f eqn="sum @7 #1 0"/>\n'+
/*16*/	'		<v:f eqn="sum @15 0 @12"/>\n'+
/*17*/	'		<v:f eqn="val 21600"/>\n'+
/*18*/	'		<v:f eqn="sum 21600 0 @4"/>\n'+
/*19*/	'		<v:f eqn="val 21600"/>\n'+
/*20*/	'		<v:f eqn="sum 21600 0 @9"/>\n'+
/*21*/	'		<v:f eqn="if #2 0 @3"/>\n'+			
/*22*/	'		<v:f eqn="sum @13 @21 0"/>\n'+			
/*23*/	'		<v:f eqn="prod @3 5 1"/>\n'+			
/*24*/	'		<v:f eqn="sum @5 0 @23"/>\n'+			
	'	</v:formulas>\n'+
	'</v:shapetype>'

if(document.all['hOptionTabModal']==null) 
	document.write(sModel)
if(document.all['vOptionTabModal']==null) 
	document.write(sModel
		.replace(sOptionTabPath,sOptionTabPath1)
		.replace(sOptionTabRect,sOptionTabRect1)
		.replace("hOptionTabModal","vOptionTabModal")
		.replace("pixelwidth","pxwidth")
		.replace("pixelheight","pixelwidth")
		.replace("pxwidth","pixelheight")
	)
function OptionTabs(name)
{
	eval("window."+name+"=this")
	this.id=name	
	var Options=document.getElementsByTagName("container")	
	for(var i=0;i<Options.length;i++)
	{
		var o=Options[i]
		this.InitContainer(o)
	}
}
OptionTabs.prototype.getWidth=function(iLength,iTmp)
{
	var i=parseInt((iLength*14)*iTmp)
	return [i,parseInt(2*iTmp)+i]
}
OptionTabs.prototype.testArea=function()
{
	try {
			var re1=/^\d+(px)?$/i
			var pWidth=e.style.width
			var pHeight=e.style.height
			if(re1.test(pWidth)==false)
				pWidth=e.clientWidth	
			if(re1.test(pHeight)==false)
				pHeight=e.clientHeight				
			var iWidth=21600/parseInt(pWidth)			
			var iHeight=21600/parseInt(pHeight)			
		} catch(exp) {alert("文档尚未完全载入,无法初始化标签！")}	
}		
OptionTabs.prototype.InitContainer=function(e)
{
	var tester=(""+this.testArea).match(/\{[\w\W]*\}/)[0]	
	eval(tester)
	var ts=(new Date()).getTime()
	this.SetDefaults(e)		
	var fillcolor=e._backgroundColor
	var sColor=e._color
	var backfillcolor=e._backfillcolor
	var backcolor=e._backcolor
	var lightcolor=e._lightcolor	
	var onaction=e.onaction||""
	var tmpTop=parseInt(iHeight)
	var iRotation=Math.abs(parseInt(e._Rotation)%360)
	var svAlign=""
	var iTmp,sType,sBoxrect,sTmp,sTmp1

	sTmp='iTmp=iWidth;sType="h";sBoxrect="5pt,17pt,5pt,5pt"'
	sTmp1='iTmp=iHeight;sType="v";sBoxrect="17pt,5pt,5pt,5pt"'
	switch(iRotation)
	{
		case 90:
			svAlign="text-align:right";iRotation=180
			sTmp=sTmp1
			break
		case 270:
			svAlign="text-align:left";iRotation=0;
			sTmp=sTmp1
			break
		case 180:
			svAlign="vertical-align:text-bottom";
			break
		default:iRotation=0;svAlign="vertical-align:baseline";break
	}
	eval(sTmp)
	var sShadowStyle='<v:shadow on="f"/>'
	if(e.EnableShadow!='f') sShadowStyle='<v:shadow on="t" color="'+e._shadowcolor+'"/>'
		
	if(onaction!="") onaction=onaction.replace(/"/g,"'")		
		
	var sShapeStyle='style="width:21600;height:21600" '
		+' fillcolor="'+backfillcolor+'" strokecolor="'+lightcolor+'" '
	var sHTML="",iTabWidth=0	
	for(var i=0;i<e.children.length;i++)
	{
		var oChild=e.children[i]
		if(oChild.tagName.toLowerCase()!="page") continue		
		var tabText=(oChild.TABTEXT||("标签"+i)).convert()		
		var onaction1=oChild.onaction||""
		if(onaction1=="") onaction1=onaction		
		var ary=this.getWidth(tabText.length,iTmp)
		var width=ary[0]	
		var sGroup = '<v:group bIsTabOptionTab="t" style="width:100%;height:100%" coordsize="21600,21600">\n'	
					+'<v:shape type="#'+sType+'OptionTabModal" '+sShapeStyle
		if(onaction1!=""&&onaction1!=" ") sGroup+='onaction="'+onaction1.replace(/"/g,"'")+'" '		
		sGroup	+='adj="'+iTabWidth+','+width+',0" TABTEXT="'+tabText+'" '
				+ 'title="'+(oChild.TABTITLE||"")+'" '+this.CopyCustomAttributes(oChild)+'>'+sShadowStyle
				+ '<v:textbox inset="0,0,0,0" style="overflow:hidden;'+svAlign+'"><span id="OptionTabName" class="TabTitle" \n'
				+ '	onclick="'+this.id+'.ChangePage(this.parentNode.parentNode.parentNode);" \n'
				+ '	style="width:100%;height:1;font-size:12px;text-align:center;cursor:default;color:'+backcolor+'" '
				+ '	onselectstart="return false" ondragstart="return false" >'+tabText
				+ '</span></v:textbox>' 
				+ '</v:shape>'
				+ '<v:rect style="width:21600;height:21600" Filled="False" Stroked="False" >\n'
				+ '<v:textbox inset="'+sBoxrect+'" id="ChildInnerHTML" >'+oChild.innerHTML+'</v:textbox>\n'
				+ '</v:rect></v:group>'
		iTabWidth+=ary[1]
		if(iTabWidth>=21600) break
		sHTML+=sGroup		
	}
	var sHTML1='<v:group style="Rotation:'+iRotation+';position:absolute;width:100%;height:100%" '+onaction+
		this.CopyCustomAttributes(e)+'coordsize="21600,21600" bIsTabOptionGroup="t"'+
		' iTabWidth="'+iTabWidth+'" TabAlignStyle="'+sType+'">'
	e.innerHTML=sHTML1+sHTML+"</v:group>"	
	e.bIsTabContainer='t'	
	//alert((new Date()).getTime()-ts)
	var oTabs=e.all['OptionTabName']
	try {oTabs[0].click()} catch(Exception) {oTabs.click()}
	setTimeout("document.all['"+e.sourceIndex+"'].style.visibility='visible'",1000)
}
OptionTabs.prototype.CopyCustomAttributes=function(e,e1)
{
	var AttriList=' '
	for(var i in e)
	{
		if(i=='') continue
		if(i.substring(0,1)=='_')
		{
			var str=i.substring(1).toLowerCase()+'='+'"'+e[i].replace(/"/g,"'")+'"'
			if(e1!=null) eval('e1.'+str)
			else AttriList+=str+' '
		}	
	}
	return AttriList
}

OptionTabs.prototype.ChangePage=function(oChild)
{	
	while(true)
	{
		if(oChild.tagName=="group") break
		oChild=oChild.parentNode
	}	
	var oContainer=oChild.parentElement
	var oChilds=oContainer.children
	var oSelected=null
	for(var i=oChilds.length-1;i>=0;i--)
	{		
		var o=oChilds[i]
		var oShape=o.children[0]
		var o2=o.getElementsByTagName("SPAN")[0].style
		var oRect=o.children[1].children[0]
		if(typeof(oShape.onaction)=="string") {
			oShape.onaction=Function("oRect",oShape.onaction)
		}
		if(o==oChild) oSelected=o
		else if(o.style.zIndex!=0) {
			o.style.zIndex=0
		//	var sValue=oShape.adj.Value.split(",")
		//	oShape.adj.Value=""+sValue[0]+","+sValue[1]+",0"
			oShape.fillcolor=oContainer.backfillcolor
			o2.color=oContainer.backcolor
			if(typeof(oShape.onaction)=="function") oRect.innerHTML=""
		}	
	}
	if(oSelected!=null) 
	{
		oSelected.style.zIndex=1
		oSelected.getElementsByTagName("SPAN")[0].style.color=oContainer.color		
		var oShape=oSelected.children[0]	
		var oRect=oSelected.children[1].children[0]		
	//	var sValue=oShape.adj.Value.split(",")
	//	oShape.adj.Value=""+sValue[0]+","+sValue[1]+",1"
		with(oShape)
		{
			setAttribute("fillcolor",oContainer.backgroundcolor)			
			if(typeof(getAttribute("onaction"))=="function") onaction(oRect)		 
		}	
	}
}

OptionTabs.prototype.SetDefaults=function(e)
{
	this.NormalDefault(e,'backgroundColor', '#393');
	this.NormalDefault(e,'color',   'white');
	this.CustomDefault(e,'TabOrientation', 'top');
	this.CustomDefault(e,'shadowcolor', 'black');
	this.CustomDefault(e,'lightcolor', 'white');
	this.CustomDefault(e,'backfillcolor', '#393');
	this.CustomDefault(e,'backcolor', '#eef');
	this.CustomDefault(e,'Rotation', '0');
}

OptionTabs.prototype.CustomDefault=function(e,sCSSName,sDefault)
{	
    var tmpStyle=e[sCSSName]
    if (tmpStyle == null)
		tmpStyle=e.style[sCSSName]
    if (tmpStyle == null)
		tmpStyle=e.currentStyle[sCSSName]
	if (tmpStyle == null)
		tmpStyle=sDefault
	e["_"+sCSSName]=tmpStyle
}
OptionTabs.prototype.NormalDefault=function(e,sCSSName, sDefault)
{
	var tmpStyle=e.style[sCSSName]
    if (tmpStyle == "transparent" ||tmpStyle ==""|| tmpStyle == null)
		tmpStyle=e.currentStyle[sCSSName]
	if (tmpStyle == "transparent" ||tmpStyle ==""|| tmpStyle == null)
		tmpStyle=sDefault		
	e.style[sCSSName]=""
	e["_"+sCSSName]=tmpStyle	
}
OptionTabs.prototype.test=function(e)
{
	if(e.bIsTabContainer=='t') e=e.children[0]
	if(e.bIsTabOptionGroup!="t") e=null	
	return e
}
OptionTabs.prototype.set=function(e,sProperty,oValue)
{
	if((e=this.test(e))==null) return
	switch(sProperty.toLowerCase())
	{
		case "rotation":			
			if(typeof(oValue)!="number") return
			var iRotation=parseInt(e.rotation)			
			var sTabStyle=e.TabAlignStyle
			var iDir,sAlign
			var eTabTitle=e.all['OptionTabName']
			oValue=Math.abs(oValue)%360
			if(oValue%90!=0) return	
			if(oValue%180!=0&&sTabStyle=="h") sTabStyle="v"
			else if(oValue%180==0&&sTabStyle=="v") sTabStyle="h"
			if(sTabStyle!=e.TabAlignStyle) e.TabAlignStyle=sTabStyle		
			iDir=(sTabStyle=="h")?oValue:270-oValue
			if(iDir!=iRotation) e.rotation=iDir			
			this.resetTabs(e)			
			break
		case "shadowon":
			for(var i=0;i<e.children.length;i++)
			e.children[i].children[0].children[0].on=oValue
			break				
	}
}
OptionTabs.prototype.addTab=function(e,sTabName,text)
{
	var e1
	if((e1=this.test(e))==null) return	
	text=text||""
	sTabName=(sTabName||("标签"+e1.children.length)).convert()
	eval((""+this.testArea).match(/\{[\w\W]*\}/)[0])
	var iTmp=(e1.TabAlignStyle=="v")?iHeight:iWidth
	var iTabWidth=parseInt(e1.iTabWidth)
	var ary=this.getWidth(sTabName.length,iTmp)
	var iLength=ary[0]	
	var iTmpWidth=iTabWidth+ary[1]
	if(iTmpWidth>21600) return
	var tShape=e1.children[0].children[0]	
	var oGroup=e1.children[0].cloneNode(true)
	oGroup.innerHTML=e1.children[0].innerHTML	
	var oShape=oGroup.children[0]	
	oShape.children[1].children[0].innerHTML=sTabName		
	oShape.removeAttribute("onaction")	
	oShape.TABTEXT=oShape.id=sTabName	
	oShape.adj=""+iTabWidth+","+iLength+",0"	
	oGroup.all['ChildInnerHTML'].innerHTML=text		
	oGroup.style.zIndex=0
	e1.iTabWidth=iTmpWidth	
	e1.appendChild(oGroup)	
	return oGroup
}
OptionTabs.prototype.removeTab=function(e,oID)
{
	var e1,tWidth,e3
	if((e1=this.test(e))==null) return
	if(typeof(oID)=="number")
	{
		e3=e1.children[oID]	
	} else {
		e2=e1.all[oID]
		if(e2==null) return
	
		if(e2.tagName==nul) e2=e2[0]
		while(true) {
			if(e2.bIsTabOptionTab=='t') break
			if(e2.tagName=="BODY") return
			e2=e2.parentNode
		}
		e3=e2
	}	
	try {
		e1.removeChild(e3)
		this.resetTabs(e1)
	} catch(Exception) {return}
}
OptionTabs.prototype.resetTabs=function(e)
{
	if((e1=this.test(e))==null) return
	e=e1.parentNode
	eval((""+this.testArea).match(/\{[\w\W]*\}/)[0])
	var sTabStyle=e1.TabAlignStyle
	var iTmp=(sTabStyle=="v")?iHeight:iWidth
	var iTabWidth=0
	var sType="#"+sTabStyle+"OptionTabModal"
	for(var i=0;i<e1.children.length;i++)
	{
		var oShape=e1.children[i].children[0]
		if(oShape.type!=sType) oShape.type=sType
		var ary=this.getWidth(oShape.getElementsByTagName("SPAN")[0].innerText.length,iTmp)
		var adj=""+iTabWidth+","+ary[0]+",0"
		iTabWidth+=ary[1]
		if(oShape.adj.Value!=adj) oShape.adj.Value=adj
	}
	e1.iTabWidth=iTabWidth
	this.resetAlign(e1)
}
OptionTabs.prototype.resetAlign=function(e)
{
	if((e1=this.test(e))==null) return
	e=e1.parentNode
	var sTabStyle=e1.TabAlignStyle
	var rotation=Math.abs(parseInt(e1.rotation)%360)
	if(sTabStyle=="v") rotation=270-rotation
	var svAlign,sInset
	switch(rotation)
	{
		case 90:
			svAlign="verticalAlign='baseline';textAlign='right'";break
		case 270:
			svAlign="verticalAlign='baseline';textAlign='left'";break
		case 180:
			svAlign="textAlign='center';verticalAlign='bottom'";break
		default:
			svAlign="textAlign='center';verticalAlign='top'";e1.rotation=0;break
	}	
	if(rotation%180==0)
		sInset="5pt,17pt,5pt,5pt"
	else
		sInset="17pt,5pt,5pt,5pt"	
	for(var i=0;i<e1.children.length;i++)
	{		
		var oRect=e1.children[i].children[1].children[0]		
		if(oRect.inset!=sInset)
		{
			oRect.inset=sInset
			var oSpan=e1.children[i].getElementsByTagName("textbox")[0]
			eval("with(oSpan.style) {"+svAlign+"}")
		}		
	}	
}