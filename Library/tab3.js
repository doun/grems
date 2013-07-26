
String.prototype.getLength=function()
{
	return this.replace(/[^\x00-\xff]/g,"**").length
}
String.prototype.Trim=function()
{
	return this.replace(/(^\s|\s$)*/g,"")
}

function OptionTabs(name)
{
	eval("window."+name+"=this")
	this.id=name
	
	var oModel=document.all['OptionTabModal']	
	if(oModel==null)
	{
		//adj参数说明：1：弧度，2：标签的高度，3：标签离左边的距离，4：标签的宽度
		var sModel= '<v:shapetype id="OptionTabModal" \n' +
					'	coordsize="21600,21600"\n'+
					'	strokecolor="white"\n'+
					'	adj="500 2000 8000 4000"\n'+
					'>\n'+
					'	<v:path v="m0,@6qy@7,@1,\n'+
					'		@3,@1,\n'+
					'		@3,@9qy@10,0,\n'+
					'		@12,0qx@11,@9,\n'+
					'		@11,@1,@14,@1qx@13,@6,@13,@16qy@14,@15,@0,@15qx0,@16xe"\n'+
					'		textboxrect="@3,@9,@11,@1;0,@2,@10,@9"\n'+
					'	/>\n'+
					'	<v:formulas>\n'+
					'		<v:f eqn="val #0"/>\n'+				//0
					'		<v:f eqn="val #1"/>\n'+				//1
					'		<v:f eqn="sum @1 @0 0"/>\n'+		//2
					'		<v:f eqn="val #2"/>\n'+				//3					
					'		<v:f eqn="prod pixelheight 100 pixelwidth" />\n'+ //4
					'		<v:f eqn="prod @0 100 @4" />\n'+	//5
					'		<v:f eqn="sum @1 @5 0"/>\n'+		//6										
					'		<v:f eqn="if @3 @0 0"/>\n'+			//7									
					'		<v:f eqn="prod @0 1 3"/>\n'+		//8
					'		<v:f eqn="prod @8 100 @4"/>\n'+		//9					
					'		<v:f eqn="sum @3 @8 0"/>\n'+		//10					
					'		<v:f eqn="sum @3 #3 0"/>\n'+		//11						
					'		<v:f eqn="sum @11 0 @8"/>\n'+		//12
					'		<v:f eqn="val width"/>\n'+			//13
					'		<v:f eqn="sum width 0 @0"/>\n'+		//14
					'		<v:f eqn="val height"/>\n'+			//15	
					'		<v:f eqn="sum height 0 @5"/>\n'+		//16	
					'	</v:formulas>\n'+   
					'</v:shapetype>\n'								
		document.body.insertAdjacentHTML("afterBegin",sModel)
	}
	
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
	this.SetDefaults(e)	
	
	var arc=parseInt(e._arcsize)
	var fillcolor=e._backgroundColor
	var color=e._color
	var backfillcolor=e._backfillcolor
	var backcolor=e._backcolor
	var lightcolor=e._lightcolor
	var ts=(new Date()).getTime()
	var onaction=e.onaction||""
	if(onaction!="") onaction='onaction="'+onaction.replace(/"/g,"'")+'" '
	
	var sHTML='<v:group style="Rotation:180;position:absolute;width:100%;height:100%;" '+onaction+
		this.CopyCustomAttributes(e)+'coordsize="2160,2160">'
	for(var i=0;i<e.children.length;i++)
	{
		var oChild=e.children[i]
		if(oChild.tagName.toLowerCase()!="page") continue
		var tabText=oChild.TABTEXT||"Tab"
		var onaction1=oChild.onaction||""
		if(onaction1!=""&&onaction!=" ") onaction1='onaction="'+onaction1.replace(/"/g,"'")+'" '
		else if(onaction1=="") onaction1=onaction
		var tabTitle=" TITLE='"+(oChild.TABTITLE||"")+"'"
		var iLength=tabText.getLength()
		var width=parseInt((iLength*7)*iWidth)
		var adj=" adj='"+arc+","+tabHeight+","+w+","+width+"'"
		w+=width+parseInt(2*iWidth)
		sHTML+= '<v:group style="width:100%;height:100%"  '+onaction1+' coordsize="21600,21600">\n'+
				'<v:shape TABTEXT="'+tabText+'" pxWidth="'+parseInt(iWidth)+'" '+this.CopyCustomAttributes(oChild)+' Type="#OptionTabModal" \n'+
				'	style="width:100%;height:100%;position:absolute;z-index:0" \n'+
				'	adj="'+adj+'" coordsize="21600,21600"\n'+
				'	fillcolor="'+backfillcolor+'" strokecolor="'+lightcolor+'"\n'+
				'>\n'+
				'<v:textbox inset="1px,0px,0px,0px">'+
				'<span id="Tab00'+(i+1)+'" class="Tab" "+tabTitle+" onclick="'+this.id+'.ChangePage(this.parentNode.parentNode.parentNode)" '+
				'style="color:'+backcolor+';width:100%;height:100%;font-size:12px;text-align:center;cursor:default" '+
				'onselectstart="return false" ondragstart="return false">'+tabText+'</span></v:textbox>\n'
		if(e.EnableShadow!='f')				
		sHTML+=	'	<v:shadow on="t" offset="1pt,1pt" color="'+e._shadowcolor+'" type="emboss" />\n'
		sHTML+=	'</v:shape>'+
				'<v:rect Filled="False" Stroked="False" \n'+
				'style="left:'+arc+';top:'+(arc+tabHeight)+';width:'+(21600-2*arc)+';height:'+(21600-2*arc-tabHeight)+'">\n'+
				'<v:textbox inset="0,0,0,0">'+oChild.innerHTML+'</v:textbox>\n'+
				'</v:rect>\n'+
				'</v:group>'
	}
	sHTML+="</v:group>"
	e.innerHTML=sHTML
	setTimeout("with(document.all['"+e.sourceIndex+"']) {all['Tab001'].click();}",500)
}
OptionTabs.prototype.CopyCustomAttributes=function(e)
{
	var AttriList=" "
	for(var i in e)
	{
		if(i=="") continue
		if(i.substring(0,1)=="_")
		AttriList+=i.substring(1).toLowerCase()+"='"+e[i].replace(/'/g,'"')+"' "
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
		if(typeof(o.onaction)=="string") {
			oShape.onaction=Function("oRect",o.onaction)
			o.onaction=null
		}
		if(o==oChild) {
			o.style.zIndex=1			
			oShape.fillcolor=oContainer.backgroundcolor
			o2.color=oContainer.color
			if(typeof(oShape.onaction)=="function")
			oShape.onaction(oRect)			
			
		} else if(o.style.zIndex!=0) {
			o.style.zIndex=0
			oShape.fillcolor=oContainer.backfillcolor
			o2.color=oContainer.backcolor
			if(typeof(oShape.onaction)=="function")
			oRect.innerHTML=""
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
	this.CustomDefault(e,'arcsize', '250');
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
