	var oPopup=window.createPopup()	
	oPopup.document.write("<BODY onmousedown='parent.oPopup.hide()' STYLE='border:0;margin:0;overflow:hidden'><DIV STYLE=\"background:#ffffcc; border:1px solid black; padding:4px; "+
				"width:100%; font-family:verdana; font-size:13px; height:100%;"+
				"filter:progid:DXImageTransform.Microsoft.Gradient(GradientType=0, "+
				"StartColorStr='yellowgreen', EndColorStr='#FFFFFF')\">"+
				"<B style='color:red'>系统提示：</B><BR>"+
				"<SPAN ID=msg>XIXI</SPAN>"+
				"</DIV>"+
				"<SCRIPT>function setContent(str) {msg.innerHTML=str}</SCRIPT></body>"
	)
	String.prototype.getLength=function()
	{
		return this.replace(/[^\x00-\xff]/g,"**").length
	}
	String.prototype.Trim=function()
	{
		return this.replace(/(^\s|\s$)*/g,"")
	}
	String.prototype.toInt=function()
	{
		var iValue=parseInt(this.replace(/[^\d]*/g,""))
		return isNaN(iValue)?0:iValue	
	}
	function getAttribute(e,sStyle,sDefault,bCustom)
	{
		var flag="tStyle==null"
		var tStyle=e.getAttribute(sStyle)
		if(bCustom!=false) flag="tStyle==null||tStyle==''"
		if(eval(flag)) tStyle=e.style[sStyle]
		if(eval(flag)) tStyle=e.currentStyle[sStyle]
		if(eval(flag)) tStyle=sDefault
		return tStyle
	}

	function SetEvent(sEventHandler,insSen,delay)
	{ 
		var reg=/\{([\W|\w]*)\}/; 
		if(typeof(sEventHandler)!="string")
		{
			alert("sEventHandler必须是字符串！")
			return
		}
		if(typeof(insSen)=="function") insSen=reg.exec(insSen.toString())[1]
		else if(typeof(insSen)=="string") 
		{
			if(typeof(delay)=="number") insSen='setTimeout("'+insSen+'",'+delay+')'
			insSen="\t"+insSen
		}
		if(typeof(insSen)!="string"	)
		{
			alert("insSen必须是字符串或者函数！")
			return
		}
	    /*插入语句到已有事件句柄中，返回一个新的Function对象*/ 
		var oEventHandler=eval(sEventHandler)
		if (oEventHandler!=null)
		{ 
			var preBody=reg.exec(oEventHandler.toString())[1]
		}else { 
			preBody=""; 
		}	
		var Args=SetEvent.arguments
		var sFun="function("
		if(Args.length>2&&typeof(delay)!="number") {
			for(var i=2;i<Args.length;i++)
			{
				if(i==2) sFun+=Args[i]
				else sFun+=","+Args[i]
			}
		}
		sFun+=") {"+preBody+insSen+"\n}"
		eval(sEventHandler+"="+sFun)
	} 

	function LoadEvent(Fun,delay)
	{
		SetEvent("window.onload",Fun,delay)
	}
	function CopyFunction(Fun)
	{
		Fun=Fun.toString()
		return Fun.replace(/function[^\(]*/,"function")	
	}	
	function alert1(sInfo,oNode)
	{			
		if(oNode==null) oNode=document.body
		oPopup.hide()
		oPopup.document.parentWindow.setContent(sInfo)	
		oPopup.show(0,0,200,0)
		var iRealHeight=oPopup.document.body.scrollHeight
		var iLeft,iTop
		oPopup.hide()
		if(oNode!=document.body) {
			iLeft=0
			iTop=-1*(iRealHeight)
		}	else {
			iLeft=parseInt((parseInt(document.body.clientWidth)-200)/2)
			iTop=parseInt((parseInt(document.body.clientHeight)-iRealHeight)/2)
		}
		oPopup.show(iLeft,iTop,200,iRealHeight,oNode)
	}