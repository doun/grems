String.prototype.Trim=function()
{
	return this.replace(/(^\s|\s$)*/g,"")
}

String.prototype.getLength=function()
{
	return this.replace(/[^\x00-\xff]/g,"**").length
}

function FlowBuilder(name)
{
	eval("window."+name+"=this")
	this.dom=new ActiveXObject("Microsoft.XMLDOM")
	var root=this.dom.createElement("ROOT")
	this.dom.appendChild(root)
}
FlowBuilder.prototype.load=function(sSpan)
{
	var oSpan=document.all[sSpan]
	oAction.innerHTML=oSpan.innerHTML
	eval(oSpan.onaction)
}
FlowBuilder.prototype.AddTab=function(e)
{
	var dom=this.dom
	var doc=this.dom.documentElement
	var oTab=dom.createElement("position")
	var sName=oAction.all["TabName"].value
	var iLevel=parseInt(oAction.all["availableLevel"].value)
	if(sName.Trim=="")
	{
		alert("请您填写标签的名称!")
		return
	
	}
	if(doc.selectSingleNode("position[@id='"+sName+"']")!=null)
	{
		alert("您不能添加一个相同名称的标签!")
		return
	}	
	oTab.setAttribute("id",sName)	
	oTab.setAttribute("level",iLevel)	
	oTab.text="xixi"
	doc.appendChild(oTab)
	this.Build()
	
}
FlowBuilder.prototype.Build=function()
{
	var doc=this.dom.documentElement
	var sGroup='<v:group CoordSize="20000,20000" CoordOrigin="-10000,-1000">'
	var vMax=0,hMax=0
	var i=0

	while(true)
	{
		++i
		var oTabs=doc.selectNodes("position[@level='"+i+"']")
		var iLength=oTabs.length
		if(iLength==0) break
		if(vMax<iLength) vMax=iLength
	}
	hMax=--i
	var matrix=[]	
	var m1=new Array(hMax)	
	i=0
	while(true)
	{
		++i
		var oTabs=doc.selectNodes("position[@level='"+i+"']")
		var iLength=oTabs.length
		if(iLength==0) break	
		matrix[matrix.length]=new Array(hMax)
		var k=parseInt((vMax-iLength)/2)		
		for(var j=0;j<iLength;j++)
		{
			var v=k+j
			var oTab=oTabs[j]
			var sTabName=oTab.getAttribute("id")
			var iTabLength=sTabName.getLength()
			matrix[v]=sTabName
			if(m1[v]==null||m1[v]<iTabLength) m1[v]=iTabLength			
		}		
	}
	sGroup+="</v:group>"
}
FlowBuilder.prototype.initTabGroup=function()
{
	
}