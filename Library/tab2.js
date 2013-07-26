String.prototype.getLength=function()
{
	return this.replace(/[^\x00-\xff]/g,"**").length
}
String.prototype.Trim=function()
{
	return this.replace(/(^\s|\s$)*/g,"")
}

//建立标签模板
var OptionTabModelShape=document.createElement('<v:shape id="OptionTabTitleContainer" \n' +
	'	coordsize="21600,21600"\n'+
	'	adj="8000 4000"\n'+
	'	style="width:100%;height:100%"\n'+
	'></v:shape>'										
)

//adj参数说明：0：标签离左边的距离，1：标签的宽度
OptionTabModelShape.innerHTML='<v:shadow on="t" offset="1pt,1pt" type="emboss" />\n'+
	'<v:path v="m0,@6qy@7,@1,'+
	'		@3,@1,'+
	'		@3,@9qy@10,0,'+
	'		@12,0qx@11,@9,'+
	'		@11,@1,@14,@1qx@13,@6,@13,@16qy@14,@15,@0,@15qx0,@16xe"\n'+
	'		textboxrect="@3,@9,@11,@1;0,@2,@10,@9"\n'+
	'	/>\n'+
	'	<v:formulas>\n'+
/*00*/	'		<v:f eqn="prod 21600 7 pixelwidth"/>\n'+			
/*01*/	'		<v:f eqn="prod 21600 18 pixelheight"/>\n'+
/*02*/	'		<v:f eqn="sum @1 @0 0"/>\n'+
/*03*/	'		<v:f eqn="val #0"/>\n'+	
/*04*/	'		<v:f eqn="prod pixelheight 100 pixelwidth" />\n'+
/*05*/	'		<v:f eqn="prod @0 100 @4" />\n'+
/*06*/	'		<v:f eqn="sum @1 @5 0"/>\n'+
/*07*/	'		<v:f eqn="if @3 @0 0"/>\n'+
/*08*/	'		<v:f eqn="prod @0 1 3"/>\n'+
/*09*/	'		<v:f eqn="prod @8 100 @4"/>\n'+
/*10*/	'		<v:f eqn="sum @3 @8 0"/>\n'+
/*11*/	'		<v:f eqn="sum @3 #1 0"/>\n'+
/*12*/	'		<v:f eqn="sum @11 0 @8"/>\n'+
/*13*/	'		<v:f eqn="val width"/>\n'+
/*14*/	'		<v:f eqn="sum width 0 @0"/>\n'+
/*15*/	'		<v:f eqn="val height"/>\n'+
/*16*/	'		<v:f eqn="sum height 0 @5"/>\n'+
	'	</v:formulas>\n'+
	'	<v:textbox inset="0px,0px,0px,0px">'+
	'		<span id="OptionTabName" class="TabTitle" \n'+
	'			onclick="OptionHandler.ChangePage(this.parentNode.parentNode.parentNode);" \n'+
	'			style="width:100%;font-size:12px;text-align:center;cursor:default" '+
	'			onselectstart="return false" ondragstart="return false" id="tabText">\n'+
	'		</span>\n'+
	'	</v:textbox>'
//建立包含标签的组	
var OptionTabModelGroup=document.createElement('<v:group style="width:100%;height:100%" coordsize="21600,21600"></v:group>')

OptionTabModelGroup.innerHTML='<v:rect style="width:100%;height:100%" Filled="False" Stroked="False" >\n'+
		'<v:textbox inset="5pt,17pt,5pt,5pt" id="ChildInnerHTML" ></v:textbox>\n'+
		'</v:rect>'
		
OptionTabModelGroup.insertAdjacentElement('afterBegin',	OptionTabModelShape)


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
OptionTabs.prototype.InitContainer=function(e)
{
	var w=0
	try {
		var pWidth=parseInt(e.clientWidth)
		var pHeight=parseInt(e.clientHeight)
		var pLeft=parseInt(e.clientLeft)
		var pTop=parseInt(e.clientTop)
		var iWidth=21600/pWidth
		var iHeight=21600/pHeight
		var tabHeight=parseInt(20*iHeight)
		
	} catch(exp) {alert("文档尚未完全载入,无法初始化标签！");return}	
	var ts=(new Date()).getTime()
	this.SetDefaults(e)	
	var arc=parseInt(10*iHeight)
	var fillcolor=e._backgroundColor
	var sColor=e._color
	var backfillcolor=e._backfillcolor
	var backcolor=e._backcolor
	var lightcolor=e._lightcolor	
	var onaction=e.onaction||""
	
	with(OptionTabModelShape)
	{
		setAttribute("pxWidth",parseInt(iWidth))
		setAttribute("pxHeight",parseInt(iHeight))
		setAttribute("fillcolor",backfillcolor)
		setAttribute("strokecolor",lightcolor)
		with(all.OptionTabName.style)
		{
		//	backgroundColor=backcolor
			color=sColor
		}
	}
	if(e.EnableShadow!='f')
		with(OptionTabModelShape.children[0])
		{
			on=true
			color=e._shadowcolor
		}	
	else OptionTabModelShape.children[0].on=false
		
	if(onaction!="") onaction=onaction.replace(/"/g,"'")		
	
	var oGroupPublic=document.createElement('<v:group'+
		' style="position:absolute;width:100%;height:100%;" '+onaction+
		this.CopyCustomAttributes(e)+'coordsize="2160,2160"></v:group>'
	)		
	
	for(var i=0;i<e.children.length;i++)
	{
	
		var oGroup=OptionTabModelGroup.cloneNode(true)
		var oChild=e.children[i]
		if(oChild.tagName.toLowerCase()!="page") continue
		var tabText=oChild.TABTEXT||"Tab"		
		var onaction1=oChild.onaction||""
		if(onaction1=="") onaction1=onaction		
		var iLength=tabText.getLength()
		var width=parseInt((iLength*7)*iWidth)		
		var oShape=oGroup.children[0]	
		if(onaction1!=""&&onaction1!=" ") oShape.onaction=Function("oRect",onaction1)						
		oShape.tempAdj=""+w+","+width
		oShape.TABTEXT=tabText
		oShape.title=oChild.TABTITLE||""
		w+=width+parseInt(2*iWidth)
		oShape.all['OptionTabName'].innerHTML=tabText		
		this.CopyCustomAttributes(oChild,oShape)		
		var oText=oGroup.all['ChildInnerHTML']
		with(oText)
		{
			style.cssText+='left:'+arc+';top:'+(arc+tabHeight)+';width:'+(21600-2*arc)+';height:'+(21600-2*arc-tabHeight)+'">'
			innerHTML=oChild.innerHTML			
		}						
		
		oGroupPublic.appendChild(oGroup)			
	}
	e.innerHTML=""
	e.appendChild(oGroupPublic)			
	var Tabs=e.getElementsByTagName('shape')
	for(var i=0;i<Tabs.length;i++)
	{
		alert(Tabs[i].adj.Value)
		if(Tabs[i].tempAdj!=null) Tabs[i].adj.Value=Tabs[i].tempAdj
	}	
	e.all['OptionTabName'][0].click()
	alert((new Date()).getTime()-ts)
	setTimeout("document.all['"+e.sourceIndex+"'].style.visibility='visible'",1000)
}
OptionTabs.prototype.CopyCustomAttributes=function(e,e1)
{
	var AttriList=" "
	for(var i in e)
	{
		if(i=="") continue
		if(i.substring(0,1)=="_")
		{
			var str=i.substring(1).toLowerCase()+"="+"'"+e[i].replace(/'/g,'"')+"'"
			if(e1!=null) eval("e1."+str)
			else AttriList+=str+" "
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
	for(var i=oChilds.length-1;i>=0;i--)
	{		
		var o=oChilds[i]
		var oShape=o.children[0]
		var o2=o.getElementsByTagName("SPAN")[0].style
		var oRect=o.children[1].children[0]
		if(typeof(oShape.onaction)=="string") {
			oShape.onaction=Function("oRect",oShape.onaction)
		}
		if(o==oChild) {			
			o.style.zIndex=1			
			oShape.fillcolor=oContainer.backgroundcolor
			o2.color=oContainer.color
			//alert(oShape.pxHeight)
			//oShape.adj.item(1)+=oShape.pxHeight
			if(typeof(oShape.onaction)=="function")	
				oShape.onaction(oRect)						
			
		} else if(o.style.zIndex!=0) {
			o.style.zIndex=0
			//oShape.adj.item(1)-=oShape.pxHeight
			oShape.fillcolor=oContainer.backfillcolor
			o2.color=oContainer.backcolor
			if(typeof(oShape.onaction)=="function") oRect.innerHTML=""
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
}

OptionTabs.prototype.CustomDefault=function(e,sCSSName,sDefault)
{	
    var tmpStyle=e.style[sCSSName]
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
