//name的作用是用来定义一个全局变量，使之指向这个类的对象
//如new SizeAranger("Sizer")相当于var Sizer=new SizeAranger()
//oFrame,frame,oDocument指的是桢的window对象、桢名及其document对象
//这样可以做到跨桢操作
function SizeAranger(name)
{
	this.id=name
	eval("window."+name+"=this")
	this.ArangerArray=[]
	SetEvent("window.onresize",name+".DoArange()",1000)
}

//把要定位的对象推送给这个类
SizeAranger.prototype.push=function(e)
{
	this.ArangerArray[this.ArangerArray.length]=e
	this.DoArange(e)
}
//定位
SizeAranger.prototype.DoArange=function(e)
{
	var ary
	if(e!=null) ary=new Array(e)
	else {ary=this.ArangerArray}
	try {
		var iWidth=document.body.offsetWidth
		var iHeight=document.body.offsetHeight
	} catch(e) {alert("文档尚未完全载入，无法定位！");return}
	for(var i=0;i<ary.length;i++)
	{
		var e1=ary[i]
		//如果该对象没有sizeformat属性，那么将continue
		//sizeformat的格式如:"width:100%-20;height:30%"		
		var format=getAttribute(e1,"sizeformat",null)
		if(typeof(format)!="string") continue
		e1.style.position="absolute"
		format=format.replace(/\s+/ig,"").toLowerCase()
		var f1=format.split(";")
		for(var i=0;i<f1.length;i++)
		{
			var f2=f1[i].split(":")
			if(f2.length!=2) continue
			var name=f2[0]			
			var value=this.getLength(name,f2[1],iWidth,iHeight)+"px"
			try {
				e1.style[name]=value		
			} catch(ex) {continue}
		}
		//如果该对象没有onresizeaction属性，那么将continue
		//否则执行该函数
		var action=getAttribute(e1,"onresizeaction",null)
		if(action!=null) 
		{
			var sType=typeof(action)
			if(sType=="function") e1.onresizeaction()
			else if(sType=="string") {
				e1.onresizeaction=Function(action)
				e1.onresizeaction()
			}
		}
	}
}
SizeAranger.prototype.getLength=function(name,value,iWidth,iHeight)
{
	var iFlag
	try {
		if(isNaN(iWidth=parseFloat(iWidth))) iWidth=document.body.offsetWidth
		if(isNaN(iHeight=parseFloat(iHeight))) iHeight=document.body.offsetHeight
	} catch(e) {alert("文档尚未完全载入，无法取值！");return -1}
	switch(name)
	{
		case "width":
		case "left":
		case "right":
			iFlag=iWidth
			break
		case "height":
		case "top":
		case "bottom":
			iFlag=iHeight
			break
		default:return -1
	}
	return eval(value.replace(/(\d+(\.\d*)?)\%/g,"(iFlag*$1/100)"))
}